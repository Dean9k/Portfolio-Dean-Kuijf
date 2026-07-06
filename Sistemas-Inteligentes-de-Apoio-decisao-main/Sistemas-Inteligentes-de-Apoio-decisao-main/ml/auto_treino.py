# Auto-treino: retreina modelo quando há 15+ novos registos de triagem
# Chamado a cada 5 minutos pelo servidor Prolog (main.pl)

import os
import subprocess
import json
from datetime import datetime

SCRIPT_DIR    = os.path.dirname(os.path.abspath(__file__))
DATASET_FILE  = os.path.join(SCRIPT_DIR, '..', 'data', 'dataset_treino.csv')
CONTROLO_FILE = os.path.join(SCRIPT_DIR, 'auto_treino_controlo.json')
TREINAR_SCRIPT = os.path.join(SCRIPT_DIR, 'treinar_modelo.py')
LIMIAR_NOVOS  = 15

# Estado anterior
if os.path.exists(CONTROLO_FILE):
    with open(CONTROLO_FILE, 'r') as f:
        controlo = json.load(f)
else:
    controlo = {'ultimo_treino_linhas': 0, 'ultimo_treino_data': None}

# Conta linhas atuais
if not os.path.exists(DATASET_FILE):
    print(f"ERRO: Dataset nao encontrado")
    exit(1)

with open(DATASET_FILE, 'r', encoding='utf-8') as f:
    linhas_atuais = sum(1 for line in f if line.strip()) - 1

linhas_anteriores = controlo['ultimo_treino_linhas']
novos_registos    = linhas_atuais - linhas_anteriores

print(f"Dataset: {linhas_atuais} | Ultimo: {linhas_anteriores} | Novos: {novos_registos} | Limiar: {LIMIAR_NOVOS}")

# Decide se retreina
if novos_registos < LIMIAR_NOVOS:
    print(f"Faltam {LIMIAR_NOVOS - novos_registos} registos para retreinar.")
else:
    print("Limiar atingido! A retreinar...")
    resultado = subprocess.run(['python3', TREINAR_SCRIPT], capture_output=False, text=True)

    if resultado.returncode == 0:
        controlo['ultimo_treino_linhas'] = linhas_atuais
        controlo['ultimo_treino_data'] = datetime.now().strftime('%Y-%m-%d %H:%M')
        with open(CONTROLO_FILE, 'w') as f:
            json.dump(controlo, f, indent=2)
        print(f"Modelo retreinado! Total: {linhas_atuais} exemplos")
    else:
        print("ERRO: Treino falhou.")