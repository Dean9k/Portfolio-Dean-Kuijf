"""
rag_sns24_gpu.py
----------------
Versão optimizada para GPU dedicada (NVIDIA GTX/RTX ou AMD RX)
TIA/SIAD · Universidade do Minho · 2025/2026

Melhorias face à versão CPU:
  1. Modelo mistral:7b — boa qualidade clínica e obediente a instruções (sem recusas)
  2. Modelfile_sns24 — system prompt fixo ao nível do modelo
  3. num_ctx=8192 — contexto longo, GPU aguenta
  4. num_gpu=99 — todas as camadas na VRAM
  5. repeat_penalty=1.15 — evita o modelo repetir frases
  6. top_p=0.9 / top_k=40 — respostas mais focadas
  7. num_predict=300 — limita respostas longas desnecessárias
  8. Retrieval MMR — chunks mais diversos (evita repetição de contexto)
  9. Histórico truncado a 6 trocas — evita overflow de contexto
  10. chunk_size=400, k=5 — mais contexto clínico por pergunta

Porquê mistral em vez de llama3.1:8b?
  llama3.1:8b tem safety training muito agressivo que ignora Modelfiles e recusa
  responder em contextos médicos. O mistral:7b é muito mais obediente a instruções.

Requisitos de VRAM:
  ≥4GB  → mistral:7b (Q4)   ← funciona
  ≥6GB  → mistral:7b (Q8)   ← recomendado
  ≥12GB → mixtral (opcional, muito mais lento)

Antes de correr:
    pip install langchain langchain-community chromadb ollama
    ollama pull mistral
    ollama pull nomic-embed-text
    python rag_sns24_gpu.py
"""

import os
from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_ollama import OllamaEmbeddings, OllamaLLM
from langchain_chroma import Chroma

# ─── CONFIGURAÇÃO ──────────────────────────────────────────────────────────────
MODELO_LLM       = "mistral"         # troca para "mixtral" se tiveres ≥12GB VRAM
MODELO_EMBEDDING = "nomic-embed-text"
CHROMA_DIR       = "./chroma_sns24_gpu"
FICHEIROS_KB     = ["sns24_kb.txt", "sns24_prolog_kb.txt"]
CHUNK_SIZE       = 400
CHUNK_OVERLAP    = 50
RETRIEVER_K      = 5
MAX_HISTORICO    = 6                # últimas N trocas a passar ao modelo
TEMPERATURE      = 0.2
NUM_CTX          = 8192             # contexto longo — GPU aguenta bem
NUM_GPU          = 99               # todas as camadas na VRAM
NUM_PREDICT      = 300              # máximo de tokens na resposta (respostas concisas)
REPEAT_PENALTY   = 1.15             # penaliza repetição de frases
TOP_P            = 0.9
TOP_K            = 40


# ─── PROMPT — o system prompt está no Modelfile, aqui só vão os protocolos e histórico ───
PROMPT_TEMPLATE = """Protocolos clínicos SNS24 (uso interno):
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


# ─── INDEXAÇÃO (só cria se não existir) ────────────────────────────────────────
embeddings    = OllamaEmbeddings(model=MODELO_EMBEDDING)
chroma_existe = os.path.exists(os.path.join(CHROMA_DIR, "chroma.sqlite3"))

if chroma_existe:
    print(f"A carregar base de dados existente de '{CHROMA_DIR}'...")
    base_dados = Chroma(
        persist_directory=CHROMA_DIR,
        embedding_function=embeddings
    )
    print("  → Base de dados carregada!")
else:
    print("Base de dados não encontrada. A criar embeddings pela primeira vez...")
    documentos = []
    for fich in FICHEIROS_KB:
        if os.path.exists(fich):
            documentos.extend(TextLoader(fich, encoding="utf-8").load())
            print(f"  → Carregado: {fich}")
        else:
            print(f"  ⚠ Não encontrado (ignorado): {fich}")

    chunks = RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP
    ).split_documents(documentos)
    print(f"  → {len(chunks)} chunks criados")

    base_dados = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory=CHROMA_DIR
    )
    print("  → Base de dados criada e guardada!")

print(f"A carregar o LLM ({MODELO_LLM}) na GPU...")
llm = OllamaLLM(
    model=MODELO_LLM,
    temperature=TEMPERATURE,
    num_ctx=NUM_CTX,
    num_gpu=NUM_GPU,
    num_predict=NUM_PREDICT,
    repeat_penalty=REPEAT_PENALTY,
    top_p=TOP_P,
    top_k=TOP_K,
    stop=["Utilizador:", "\nUtilizador", "Tu:"],
)

# MMR (Maximal Marginal Relevance) — chunks mais diversos, evita redundância
retriever = base_dados.as_retriever(
    search_type="mmr",
    search_kwargs={"k": RETRIEVER_K, "fetch_k": RETRIEVER_K * 3, "lambda_mult": 0.7}
)
print("  → Chatbot pronto!\n")


# ─── LOOP DE CONVERSA ──────────────────────────────────────────────────────────
print("=" * 50)
print(f"Assistente SNS24 [GPU / {MODELO_LLM}]")
print("(escreve 'sair' para terminar)")
print("(escreve 'debug' para ver os chunks usados)")
print("(escreve 'reset' para limpar o histórico)")
print("=" * 50)

historico = []

while True:
    mensagem = input("\nTu: ").strip()
    if not mensagem:
        continue
    if mensagem.lower() == "sair":
        break
    if mensagem.lower() == "reset":
        historico = []
        print("  → Histórico limpo.")
        continue

    todas_as_mensagens = " ".join([u for u, _ in historico]) + " " + mensagem
    docs_relevantes    = retriever.invoke(todas_as_mensagens.strip())

    if mensagem.lower() == "debug":
        print("\n--- CHUNKS USADOS ---")
        for i, doc in enumerate(docs_relevantes):
            print(f"\nChunk {i+1}:\n{doc.page_content}")
        print("--- FIM DEBUG ---")
        continue

    contexto = "\n\n".join(doc.page_content for doc in docs_relevantes)

    # Trunca histórico às últimas N trocas para não exceder contexto
    historico_recente = historico[-MAX_HISTORICO:]
    historico_texto = ""
    for user_msg, bot_msg in historico_recente:
        historico_texto += f"Utilizador: {user_msg}\nAssistente: {bot_msg}\n"
    if not historico_texto:
        historico_texto = "(início da chamada)"

    prompt = PROMPT_TEMPLATE.format(
        context=contexto,
        historico=historico_texto,
        pergunta=mensagem
    )

    # Streaming — o texto aparece palavra a palavra
    print("\nAssistente: ", end="", flush=True)
    resposta_completa = ""
    for chunk in llm.stream(prompt):
        print(chunk, end="", flush=True)
        resposta_completa += chunk
    print()

    historico.append((mensagem, resposta_completa))
