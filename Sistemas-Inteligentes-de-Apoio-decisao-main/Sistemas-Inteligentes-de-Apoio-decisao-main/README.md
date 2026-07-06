# Sistema Inteligente de Triagem Clínica (Inspirado no SNS24)

Um Sistema Inteligente de Apoio à Decisão (SIAD) desenvolvido em Prolog e Web (HTML/CSS/JS). Implementa um Sistema Pericial focado na triagem de sintomas, com encaminhamento clínico baseado em Fatores de Certeza (CF), Machine Learning e um Chatbot RAG integrado.

---

## Funcionalidades Principais

- **Motor de Inferência com Incerteza**: Avalia respostas dicotómicas (Sim/Não) e escalas de intensidade (0–10) aplicando Fatores de Certeza (CF) para calcular a confiança no encaminhamento final.
- **Interface Web Interativa (SPA)**: Frontend moderno e responsivo com seleção de fluxo de triagem, barra de progresso e timer de sessão, criado com Vanilla JavaScript.
- **Fluxos de Triagem**: O utilizador seleciona o grupo de sintomas antes de iniciar — Respiratório, Febre/Gastrointestinal ou Outros Sintomas. As perguntas são filtradas por fluxo para evitar questões irrelevantes.
- **Gestão de Utentes**: Identificação via NIF (9 dígitos) com cálculo automático da idade a partir da Data de Nascimento. Registo imediato se o NIF não existir.
- **Histórico de Triagens**: Gravação automática de todas as triagens e consulta de histórico por NIF.
- **Modo Claro / Escuro**: Alternância de tema guardada em localStorage.
- **Persistência em CSV**: Ficheiros `.csv` leves para utentes, triagens e dataset de treino — sem necessidade de base de dados externa.
- **Machine Learning**: Árvore de Decisão treinada sobre as triagens reais, cujas regras são injetadas automaticamente na base de conhecimento Prolog.
- **Chatbot RAG integrado**: Assistente conversacional em linguagem natural disponível diretamente na interface web, alimentado por Mistral 7B via Ollama.

---

## Arquitetura e Tecnologias

```
┌─────────────────────────────────────────────────────────┐
│                   Browser (localhost:8000)               │
│            HTML5 · CSS3 · JavaScript (ES6+)             │
└───────────────────────┬─────────────────────────────────┘
                        │ HTTP / JSON API
┌───────────────────────▼─────────────────────────────────┐
│         Backend Prolog (SWI-Prolog · porta 8000)        │
│  main.pl · motor.pl · conhecimento.pl · identificacao.pl│
│  Auto-treino ML (thread em background, cada 5 min)      │
│  Inicia automaticamente o servidor RAG ao arrancar      │
└──────────┬────────────────────────────┬─────────────────┘
           │ subprocess (python3)        │ HTTP (localhost:8001)
┌──────────▼──────────┐      ┌──────────▼─────────────────┐
│  ML (Python · ml/)  │      │  Chatbot RAG (porta 8001)  │
│  treinar_modelo.py  │      │  Flask · Ollama · ChromaDB │
│  Árvore de Decisão  │      │  Mistral 7B · RAG          │
│  → injeta regras PL │      │  (iniciado pelo Prolog)    │
└─────────────────────┘      └────────────────────────────┘
```

- **Backend / Lógica**: SWI-Prolog como servidor HTTP e motor de inferência.
- **Frontend**: HTML5, CSS3 (CSS Variables) e JavaScript (ES6+).
- **Machine Learning**: Python 3 com `scikit-learn`, `pandas`, `matplotlib`.
- **Chatbot**: Flask + LangChain + ChromaDB + Ollama (Mistral 7B).

---

## Estrutura de Ficheiros

```
projeto/
├── backend/
│   ├── main.pl                   # Servidor HTTP, rotas da API e arranque automático do RAG
│   ├── motor.pl                  # Motor de inferência com factores de certeza
│   ├── conhecimento.pl           # Base de conhecimento (~47 regras manuais + ~102 regras ML)
│   ├── identificacao.pl          # Gestão de utentes e persistência CSV
│   └── metricas_ml.json          # Métricas do modelo ML (gerado automaticamente)
├── frontend/
│   ├── index.html                # Interface principal (SPA)
│   ├── script.js                 # Lógica JavaScript (fluxos, triagem, chatbot, histórico)
│   └── style.css                 # Estilos CSS (modo claro/escuro, responsivo)
├── data/
│   ├── utentes.csv               # Base de dados de utentes (NIF, nome, data nascimento)
│   ├── triagens.csv              # Histórico de todas as triagens realizadas
│   └── dataset_treino.csv        # Dataset acumulado para re-treino do modelo ML
├── ml/
│   ├── gerar_dataset.py          # Gera dataset sintético inicial
│   ├── treinar_modelo.py         # Treina a Árvore de Decisão e injeta regras no Prolog
│   ├── auto_treino.py            # Verifica se há 15+ novos registos e retreina se necessário
│   ├── auto_treino_controlo.json # Estado do auto-treino (gerado automaticamente)
│   ├── metricas_ml.json          # Métricas do último treino (gerado automaticamente)
│   └── metricas_img/             # Gráficos: matriz de confusão, importâncias, árvore
├── chatbot/
│   ├── rag_sns24_gpu.py          # Chatbot standalone de terminal (Mistral 7B via Ollama)
│   ├── servidor_rag_gpu.py       # Servidor Flask do chatbot (porta 8001, iniciado pelo Prolog)
│   ├── gerar_prolog_kb.py        # Exporta conhecimento.pl → sns24_prolog_kb.txt
│   ├── requirements.txt          # Dependências Python do chatbot
│   ├── sns24_kb.txt              # Protocolos clínicos SNS24 (base do RAG)
│   ├── sns24_prolog_kb.txt       # Regras Prolog exportadas (gerado automaticamente)
│   ├── chroma_sns24_gpu/         # Base vetorial ChromaDB (usada pelo servidor Flask)
│   └── chroma_sns24_api/         # Base vetorial ChromaDB alternativa
├── docs/
│   └── Logo-SNS.png              # Logo do SNS24
└── README.md
```

---

## Pré-requisitos

| Componente | Requisito |
|---|---|
| Backend | [SWI-Prolog](https://www.swi-prolog.org/) |
| Machine Learning | Python 3 + `pip install pandas scikit-learn matplotlib` |
| Chatbot RAG | Python 3 + Ollama + dependências abaixo |

```bash
# Dependências do chatbot
pip install langchain langchain-community langchain-ollama langchain-chroma chromadb ollama flask flask-cors

# Modelos Ollama
ollama pull mistral
ollama pull nomic-embed-text
```

---

## Como Executar

### 1. Iniciar o servidor (tudo de uma vez)

```bash
cd backend
swipl main.pl
```

Na consola Prolog, executa:

```prolog
?- iniciar.
```

O predicado `iniciar/0` faz **tudo automaticamente**:
1. Inicia o servidor HTTP na porta **8000**.
2. Lança o **auto-treino ML** em background (verifica a cada 5 minutos).
3. Inicia o **servidor do chatbot RAG** em background (porta **8001**).

Mensagem esperada:
```
*** Servidor SNS24 em http://localhost:8000 ***
*** Base de conhecimento: Parte A (manual) + Parte B (ML) ***
*** Auto-treino ML ativo (verifica a cada 5 minutos) ***
*** Servidor RAG a iniciar em http://localhost:8001 ***
```

### 2. Aceder à aplicação

Abre o browser e acede a:
```
http://localhost:8000
```

O chatbot já está disponível na interface web (requer Ollama com os modelos instalados).

---

## Como Usar a Aplicação

1. **Identificação**: Introduz o NIF (9 dígitos). Se não existir, preenche o formulário de registo com nome e data de nascimento.
2. **Seleção de Fluxo**: Escolhe o grupo de sintomas que melhor descreve a situação — Respiratório, Febre/Gastrointestinal ou Outros Sintomas.
3. **Triagem**: O sistema faz perguntas dinâmicas adaptadas ao fluxo escolhido. Responde com Sim/Não ou numa escala de 0 a 10.
4. **Resultado**: O motor de inferência apresenta o encaminhamento (ex: Emergência 112, Consulta Médica, Autocuidados), com justificação clínica e Grau de Certeza (%).
5. **Histórico**: Clica em "Ver Histórico" para consultar todas as triagens anteriores do NIF autenticado.
6. **Chatbot**: Disponível em qualquer momento na interface web para perguntas em linguagem natural sobre sintomas e protocolos clínicos.

---

## Base de Conhecimento

A base de conhecimento em `backend/conhecimento.pl` é composta por **~149 regras** organizadas em duas partes:

### Parte A — Regras Manuais (~47 regras)
Regras de produção escritas manualmente, baseadas em protocolos clínicos SNS24. Cobrem situações como:
- Emergências vitais (AVC, enfarte, meningite, anafilaxia, etc.)
- Urgência hospitalar (pneumonia, apendicite, crises asmáticas, etc.)
- Consulta médica (infeções, otites, problemas de garganta, etc.)
- Autocuidados com e sem vigilância

### Parte B — Regras ML (~102 regras, geradas automaticamente)
Regras geradas pela Árvore de Decisão e injetadas entre os marcadores:
```prolog
% === INICIO REGRAS PARTE B (geradas por ML) ===
...
% === FIM REGRAS PARTE B (geradas por ML) ===
```

Ambas as partes usam o mesmo predicado `encaminhamento/3` com Fatores de Certeza, permitindo integração transparente. O motor percorre sempre a Parte A primeiro.

### Fluxos de Triagem
As perguntas são agrupadas em **3 fluxos** para evitar perguntas irrelevantes:
- `respiratorio` — sintomas respiratórios e pulmonares
- `febre_geral` — febre, gastrointestinais, garganta
- `outros` — cardiovascular, neurológico, urinário, ortopédico, gravidez, etc.

Algumas perguntas (emergência, doenças crónicas, imunossupressão) são comuns a todos os fluxos.

---

## Machine Learning

### Treinar o modelo manualmente

```bash
cd ml
python treinar_modelo.py
```

O script:
- Lê `data/dataset_treino.csv` (acumulado pelas triagens reais)
- Treina uma Árvore de Decisão com `RandomizedSearchCV`
- Injeta as regras geradas em `backend/conhecimento.pl` (substituindo a Parte B)
- Gera gráficos em `ml/metricas_img/` (matriz de confusão, importâncias, árvore)
- Guarda métricas em `ml/metricas_ml.json`

### (Opcional) Gerar dataset sintético inicial

```bash
cd ml
python gerar_dataset.py
```

Útil antes de existirem triagens reais suficientes.

### Auto-treino automático

O servidor Prolog executa `auto_treino.py` a cada **5 minutos** em background. O script retreina o modelo automaticamente quando há **15 ou mais novos registos** de triagem desde o último treino — sem intervenção manual.

---

## Chatbot RAG

O chatbot integrado usa **RAG (Retrieval-Augmented Generation)** com duas fontes de conhecimento:
- `chatbot/sns24_kb.txt` — protocolos clínicos SNS24 (febre, dor no peito, alergias, etc.)
- `chatbot/sns24_prolog_kb.txt` — regras de triagem exportadas do `conhecimento.pl` (Partes A e B)

### Modos de uso

**No frontend web** (recomendado): o servidor Flask é iniciado automaticamente pelo Prolog ao executar `iniciar.`. O chatbot aparece integrado na interface em `http://localhost:8000`.

**No terminal** (standalone, sem necessidade do servidor Prolog):
```bash
cd chatbot
python rag_sns24_gpu.py
```

Comandos disponíveis no modo terminal:

| Comando | Descrição |
|---------|-----------|
| `debug` | Mostra os chunks de conhecimento usados na resposta |
| `reset` | Limpa o histórico da conversa |
| `sair`  | Termina o chatbot |

### Atualizar o chatbot após novo treino ML

Sempre que o modelo ML for re-treinado, regenera o ficheiro de conhecimento do RAG para que o chatbot reflita as novas regras:

```bash
cd chatbot
python gerar_prolog_kb.py
```

A base vetorial ChromaDB é recriada automaticamente na próxima execução.

---

## API HTTP (Referência)

O servidor Prolog expõe os seguintes endpoints na porta 8000:

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/user` | Verificar NIF ou registar novo utente |
| `POST` | `/api/triage` | Executar passo de triagem (pergunta ou resultado) |
| `POST` | `/api/history` | Obter histórico de triagens por NIF |
| `GET`  | `/api/metricas_ml` | Métricas do modelo ML atual |
| `POST` | `http://localhost:8001/chat` | Chatbot RAG (Mistral 7B) |

---

## Aviso Legal / Disclaimer

Este é um projeto estritamente académico (TIA/SIAD · Universidade do Minho · 2025/2026). O conhecimento clínico aqui codificado é uma aproximação para fins educativos no âmbito de disciplinas de Inteligência Artificial / Sistemas de Apoio à Decisão e **NÃO DEVE ser utilizado para diagnósticos médicos reais ou tomada de decisão em saúde**.

Em caso de emergência médica real, ligue sempre:
- **112** — Emergência Nacional
- **808 24 24 24** — SNS24 (Linha de Saúde)
