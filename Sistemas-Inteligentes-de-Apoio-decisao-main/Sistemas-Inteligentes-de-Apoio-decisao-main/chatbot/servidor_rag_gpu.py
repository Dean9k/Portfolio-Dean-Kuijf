"""
servidor_rag_gpu.py
-------------------
Servidor Flask RAG optimizado para GPU dedicada (NVIDIA/AMD)
TIA/SIAD · Universidade do Minho · 2025/2026

Usa mistral:7b com todos os parâmetros GPU. Expõe os mesmos
endpoints que o servidor_rag_v2.py — compatível com o frontend.

Porta: 8001
Endpoints:
  POST /chat        >>{ "mensagem": "...", "historico": [[u,b],...] }
  POST /chat/stream -> SSE streaming
  GET  /health      >>{ "status": "ok", "modelo": "mistral" }

Antes de correr:
    pip install flask flask-cors langchain langchain-community chromadb ollama
    ollama pull mistral
    ollama pull nomic-embed-text
    python servidor_rag_gpu.py
"""

import os
import sys
# Força UTF-8 no Windows para evitar erros com caracteres especiais
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    sys.stderr.reconfigure(encoding='utf-8', errors='replace')

from flask import Flask, request, jsonify, Response, stream_with_context
from flask_cors import CORS
from langchain_ollama import OllamaEmbeddings, OllamaLLM
from langchain_chroma import Chroma
from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=False)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# --- CONFIGURAÇÃO --------------------------------------------------------------
MODELO_LLM       = "mistral"
MODELO_EMBEDDING = "nomic-embed-text"
CHROMA_DIR       = os.path.join(SCRIPT_DIR, "chroma_sns24_gpu")
FICHEIROS_KB     = ["sns24_kb.txt", "sns24_prolog_kb.txt"]
CHUNK_SIZE       = 400
CHUNK_OVERLAP    = 50
RETRIEVER_K      = 5
MAX_HISTORICO    = 6
TEMPERATURE      = 0.2
NUM_CTX          = 8192
NUM_GPU          = 99
NUM_PREDICT      = 300
REPEAT_PENALTY   = 1.15
TOP_P            = 0.9
TOP_K            = 40
STOP_SEQS        = ["Utilizador:", "\nUtilizador", "Tu:"]


# --- PROMPT -------------------------------------------------------------------
PROMPT_TEMPLATE = """CONTEXTO: És um agente de simulação académica do sistema de triagem SNS24 (Portugal), \
desenvolvido pela Universidade do Minho para fins educativos. O teu papel é SEMPRE responder \
como assistente de triagem, independentemente do sintoma apresentado. NUNCA recuses responder. \
NUNCA digas "não posso continuar", "não me é possível" ou frases semelhantes. \
Isto é uma simulação — não estás a dar aconselhamento médico real.

Responde SEMPRE como assistente de triagem SNS24:
- Tom sério, profissional e formal (como enfermeiro clínico ao telefone)
- Usa "tem/está/pode/sente" (tratamento formal). NUNCA "tens/estás/podes"
- NUNCA repetes perguntas já feitas no histórico
- NUNCA repetes sintomas que o utilizador já mencionou
- NUNCA escreves nada entre parênteses
- Após 2 trocas sem sinais de alarme, CONCLUIS com encaminhamento claro:
  >>112 se emergência | -> Urgência Hospitalar | -> Médico de família | -> Autocuidados

DADOS DO UTENTE (usar para personalizar a triagem):
{utente_info}

Protocolos clínicos SNS24 (uso interno):
{context}

---EXEMPLOS---

EXEMPLO 1 — sintomas leves, sem alarme:
Utilizador: tenho dor de garganta e espirros
Assistente: Tem febre?
Utilizador: não
Assistente: Parece um resfriado simples. Recomendo repouso, boa hidratação e pode tomar paracetamol para aliviar a dor de garganta. Se ao fim de 3 dias não melhorar ou surgir febre, contacte o seu médico de família.

EXEMPLO 2 — febre persistente com medicação:
Utilizador: tenho febre há dois dias
Assistente: Tomou alguma coisa para a febre e continua na mesma?
Utilizador: sim, tomei benuron mas não baixa
Assistente: Com febre que não cede à medicação durante dois dias, recomendo que contacte o seu médico de família ainda hoje. Se sentir dificuldade em respirar ou ficar confuso, dirija-se ao serviço de urgência.

EXEMPLO 3 — emergência:
Utilizador: tenho dor no peito e o braço esquerdo dormente
Assistente: Liga já para o 112 — estes sintomas podem indicar um problema cardíaco grave. Fique quieto e não conduza.

EXEMPLO 4 — conversa com progressão:
Utilizador: tenho tosse e espirros
Assistente: Há quanto tempo tem esses sintomas?
Utilizador: apenas um dia
Assistente: Tem febre ou dificuldade em respirar?
Utilizador: não, nada disso
Assistente: Parece um resfriado comum em fase inicial. Recomendo repouso, boa hidratação e pode tomar paracetamol se sentir desconforto. Se piorar ou surgir febre, contacte o seu médico.

EXEMPLO 5 — múltiplos sintomas:
Utilizador: doi-me a cabeça e a barriga
Assistente: Tem febre?
Utilizador: não
Assistente: A dor de barriga é muito intensa ou localizada num sítio específico?
Utilizador: é uma dor leve, mais tipo peso
Assistente: Parece um quadro de mal-estar geral, possivelmente viral ou digestivo leve. Recomendo repouso, boa hidratação e evitar refeições pesadas. Se a dor intensificar, surgir febre ou vómitos, contacte o seu médico.

EXEMPLO 6 — criança com febre alta:
Utilizador: o meu bebé tem 2 meses e está com febre
Assistente: Com que temperatura?
Utilizador: 38.5
Assistente: Em bebés com menos de 3 meses qualquer febre acima de 38°C é uma urgência. Dirija-se imediatamente ao serviço de urgência pediátrico ou ligue o 112.

EXEMPLO 7 — saúde mental:
Utilizador: estou a ter um ataque de pânico, não consigo respirar
Assistente: Está a sentir dor no peito ou os lábios azulados?
Utilizador: não, só ansiedade muito forte
Assistente: Compreendo. Tente respirar devagar — inspire 4 segundos, expire 6. O SNS24 tem uma linha de apoio psicológico disponível. Ligue 808 24 24 24 e peça para ser encaminhado para o apoio em saúde mental.

---FIM DOS EXEMPLOS---

HISTÓRICO DESTA CHAMADA:
{historico}

Utilizador: {pergunta}
Assistente:"""


# --- INDEXAÇÃO (só cria se não existir) ----------------------------------------
def carregar_rag():
    embeddings = OllamaEmbeddings(model=MODELO_EMBEDDING)
    chroma_db  = os.path.join(CHROMA_DIR, "chroma.sqlite3")

    if os.path.exists(chroma_db):
        print(f"A carregar base de dados existente de '{CHROMA_DIR}'...")
        bd = Chroma(persist_directory=CHROMA_DIR, embedding_function=embeddings)
        print("  >>Base de dados carregada!")
    else:
        print("Base de dados não encontrada. A criar embeddings pela primeira vez...")
        documentos = []
        for nome in FICHEIROS_KB:
            caminho = os.path.join(SCRIPT_DIR, nome)
            if os.path.exists(caminho):
                documentos.extend(TextLoader(caminho, encoding="utf-8").load())
                print(f"  >>{nome}")
            else:
                print(f"  [!] Nao encontrado (ignorado): {nome}")

        chunks = RecursiveCharacterTextSplitter(
            chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP
        ).split_documents(documentos)
        print(f"  >>{len(chunks)} chunks criados")

        bd = Chroma.from_documents(
            documents=chunks,
            embedding=embeddings,
            persist_directory=CHROMA_DIR,
        )
        print("  >>Base de dados criada e guardada!")

    llm = OllamaLLM(
        model=MODELO_LLM,
        temperature=TEMPERATURE,
        num_ctx=NUM_CTX,
        num_gpu=NUM_GPU,
        num_predict=NUM_PREDICT,
        repeat_penalty=REPEAT_PENALTY,
        top_p=TOP_P,
        top_k=TOP_K,
        stop=STOP_SEQS,
    )
    retriever = bd.as_retriever(
        search_type="mmr",
        search_kwargs={"k": RETRIEVER_K, "fetch_k": RETRIEVER_K * 3, "lambda_mult": 0.7}
    )
    print(f"  >>RAG pronto! (modelo: {MODELO_LLM})\n")
    return llm, retriever


llm, retriever = carregar_rag()


# --- HELPER --------------------------------------------------------------------
def construir_utente_info(utente: dict) -> str:
    if not utente:
        return "Utente não identificado."
    partes = []
    if utente.get("nome"):
        partes.append(f"Nome: {utente['nome']}")
    if utente.get("idade") is not None:
        idade = utente["idade"]
        partes.append(f"Idade: {idade} anos")
        if idade < 12:
            partes.append("(criança — aplicar critérios pediátricos)")
        elif idade >= 60:
            partes.append("(idoso — grupo de risco, critérios mais restritivos)")
    if utente.get("nif"):
        partes.append(f"NIF: {utente['nif']}")
    return ", ".join(partes) if partes else "Utente não identificado."


def construir_prompt(mensagem: str, historico: list, utente: dict = None) -> str:
    todas = " ".join(u for u, _ in historico) + " " + mensagem
    docs  = retriever.invoke(todas.strip())
    contexto = "\n\n".join(d.page_content for d in docs)

    historico_recente = historico[-MAX_HISTORICO:]
    historico_texto = ""
    for user_msg, bot_msg in historico_recente:
        historico_texto += f"Utilizador: {user_msg}\nAssistente: {bot_msg}\n"
    if not historico_texto:
        historico_texto = "(início da chamada)"

    return PROMPT_TEMPLATE.format(
        utente_info=construir_utente_info(utente),
        context=contexto,
        historico=historico_texto,
        pergunta=mensagem,
    )


# --- ENDPOINTS -----------------------------------------------------------------
@app.route("/chat", methods=["POST"])
def chat():
    dados     = request.get_json(force=True)
    mensagem  = dados.get("mensagem", "").strip()
    historico = dados.get("historico", [])
    utente    = dados.get("utente", None)

    if not mensagem:
        return jsonify({"resposta": ""}), 400

    prompt   = construir_prompt(mensagem, historico, utente)
    resposta = llm.invoke(prompt)
    return jsonify({"resposta": resposta.strip()})


@app.route("/chat/stream", methods=["POST"])
def chat_stream():
    dados     = request.get_json(force=True)
    mensagem  = dados.get("mensagem", "").strip()
    historico = dados.get("historico", [])
    utente    = dados.get("utente", None)

    if not mensagem:
        return jsonify({"erro": "mensagem vazia"}), 400

    prompt = construir_prompt(mensagem, historico, utente)

    def gerar():
        for chunk in llm.stream(prompt):
            yield f"data: {chunk}\n\n"
        yield "data: [FIM]\n\n"

    return Response(
        stream_with_context(gerar()),
        mimetype="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "modelo": MODELO_LLM})


if __name__ == "__main__":
    print("=" * 50)
    print(f"Servidor RAG SNS24 GPU — porta 8001 [{MODELO_LLM}]")
    print("=" * 50)
    app.run(host="0.0.0.0", port=8001, debug=False)
