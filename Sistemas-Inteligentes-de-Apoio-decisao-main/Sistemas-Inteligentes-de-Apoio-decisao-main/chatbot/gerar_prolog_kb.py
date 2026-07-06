"""
gerar_prolog_kb.py
------------------
Converte o conhecimento.pl (regras manuais + regras ML) para texto legível
e gera sns24_prolog_kb.txt para ser indexado pelo chatbot RAG.

Executar sempre que o modelo ML re-treinar:
    python gerar_prolog_kb.py
"""

import re
import os

SCRIPT_DIR      = os.path.dirname(os.path.abspath(__file__))
CONHECIMENTO_PL = os.path.join(SCRIPT_DIR, '..', 'backend', 'conhecimento.pl')
OUTPUT_FILE     = os.path.join(SCRIPT_DIR, 'sns24_prolog_kb.txt')

DESTINOS_PT = {
    'emergencia_112':          'EMERGÊNCIA 112',
    'urgencia_hospitalar':     'URGÊNCIA HOSPITALAR',
    'consulta_medica':         'CONSULTA MÉDICA',
    'contacto_sns24':          'CONTACTO SNS24',
    'linha_saude_mental':      'LINHA SAÚDE MENTAL',
    'autocuidados_vigilancia': 'AUTOCUIDADOS COM VIGILÂNCIA',
    'autocuidados':            'AUTOCUIDADOS',
}

DESCRICAO_DESTINOS = {
    'emergencia_112':          'Ligar 112 imediatamente. Situação de risco de vida.',
    'urgencia_hospitalar':     'Ir ao Serviço de Urgência Hospitalar nas próximas 2 horas.',
    'consulta_medica':         'Marcar consulta com médico de família em 24 a 48 horas.',
    'contacto_sns24':          'Contactar a linha SNS24 (808 24 24 24) para aconselhamento.',
    'linha_saude_mental':      'Contactar a linha de apoio psicológico do SNS24.',
    'autocuidados_vigilancia': 'Tratar em casa com vigilância. Reavaliação em 24 a 48 horas.',
    'autocuidados':            'Tratar em casa. Sem necessidade de contacto imediato com serviços de saúde.',
}


def ler_ficheiro(caminho):
    with open(caminho, encoding='utf-8') as f:
        return f.read()


def extrair_texto_pergunta(conteudo):
    padrao = r"texto_pergunta\((\w+),\s*'([^']+)'\)"
    return dict(re.findall(padrao, conteudo))


def extrair_motivo_pergunta(conteudo):
    padrao = r"motivo_pergunta\((\w+),\s*'([^']+)'\)"
    return dict(re.findall(padrao, conteudo))


def extrair_encaminhamentos(conteudo):
    padrao = r"encaminhamento\((\w+),\s*'([^']+)',\s*\w+\)\s*:-\s*(.*?)(?=\n\n|\nencaminhamento|\n%|\Z)"
    resultados = re.findall(padrao, conteudo, re.DOTALL)
    regras = []
    for destino, justificacao, corpo in resultados:
        sintomas_exatos   = re.findall(r"verifica_exato\(sintoma,\s*(\w+),", corpo)
        sintomas_negativos = re.findall(r"verifica_negativo\(sintoma,\s*(\w+),", corpo)
        cf_regra = re.search(r"CF_Regra\s*=\s*([\d.]+)", corpo)
        cf_valor = float(cf_regra.group(1)) if cf_regra else None
        regras.append({
            'destino':   destino,
            'justificacao': justificacao,
            'exatos':    sintomas_exatos,
            'negativos': sintomas_negativos,
            'cf':        cf_valor,
        })
    return regras


def e_regra_ml(justificacao):
    return justificacao.startswith('ML:')


def gerar_texto(perguntas, motivos, regras):
    linhas = []

    linhas.append("# Base de Conhecimento SNS24 — Regras de Triagem (Prolog + ML)")
    linhas.append("# Gerado automaticamente a partir de backend/conhecimento.pl")
    linhas.append("# ============================================================")
    linhas.append("")

    # Secção 1: sintomas e perguntas de triagem
    linhas.append("## SINTOMAS E PERGUNTAS DE TRIAGEM")
    linhas.append("")
    linhas.append("Cada sintoma abaixo corresponde a uma pergunta feita ao utente durante a triagem.")
    linhas.append("A resposta é usada pelo motor de inferência para calcular o encaminhamento.")
    linhas.append("")
    for sintoma, pergunta in perguntas.items():
        motivo = motivos.get(sintoma, '')
        linhas.append(f"Sintoma: {sintoma}")
        linhas.append(f"  Pergunta: {pergunta}")
        if motivo:
            linhas.append(f"  Motivo clínico: {motivo}")
        linhas.append("")

    linhas.append("---")
    linhas.append("")

    # Secção 2: destinos possíveis
    linhas.append("## ENCAMINHAMENTOS POSSÍVEIS")
    linhas.append("")
    for codigo, nome in DESTINOS_PT.items():
        linhas.append(f"### {nome}")
        linhas.append(f"  {DESCRICAO_DESTINOS[codigo]}")
        linhas.append("")

    linhas.append("---")
    linhas.append("")

    # Secção 3: regras manuais (Parte A)
    linhas.append("## REGRAS DE TRIAGEM MANUAIS (Parte A)")
    linhas.append("")
    linhas.append("Estas regras foram definidas manualmente com base em protocolos clínicos SNS24.")
    linhas.append("")

    regras_manuais = [r for r in regras if not e_regra_ml(r['justificacao'])]
    for r in regras_manuais:
        destino_pt = DESTINOS_PT.get(r['destino'], r['destino'])
        linhas.append(f"Encaminhamento: {destino_pt}")
        linhas.append(f"  Justificação: {r['justificacao']}")
        if r['exatos']:
            linhas.append(f"  Sintomas presentes: {', '.join(r['exatos'])}")
        if r['negativos']:
            linhas.append(f"  Sintomas ausentes: {', '.join(r['negativos'])}")
        if r['cf'] is not None:
            linhas.append(f"  Grau de certeza da regra: {r['cf']:.0%}")
        linhas.append("")

    linhas.append("---")
    linhas.append("")

    # Secção 4: resumo das regras ML (Parte B)
    linhas.append("## REGRAS DE TRIAGEM GERADAS POR MACHINE LEARNING (Parte B)")
    linhas.append("")
    linhas.append("Estas regras foram aprendidas automaticamente por uma Árvore de Decisão")
    linhas.append("treinada no dataset de triagens reais. Complementam as regras manuais.")
    linhas.append("")

    regras_ml = [r for r in regras if e_regra_ml(r['justificacao'])]
    contagem_por_destino = {}
    for r in regras_ml:
        contagem_por_destino.setdefault(r['destino'], []).append(r)

    for destino, lista in contagem_por_destino.items():
        destino_pt = DESTINOS_PT.get(destino, destino)
        linhas.append(f"### {destino_pt} ({len(lista)} regras ML)")
        for r in lista[:5]:  # mostra as 5 primeiras de cada classe para não inflar demasiado o texto
            if r['exatos']:
                linhas.append(f"  - Padrão: {', '.join(r['exatos'])} presentes → {destino_pt}")
            if r['negativos']:
                linhas.append(f"    (ausentes: {', '.join(r['negativos'])})")
        if len(lista) > 5:
            linhas.append(f"  ... e mais {len(lista) - 5} padrões aprendidos.")
        linhas.append("")

    return "\n".join(linhas)


def main():
    if not os.path.exists(CONHECIMENTO_PL):
        print(f"ERRO: {CONHECIMENTO_PL} não encontrado.")
        return

    print("A ler conhecimento.pl...")
    conteudo = ler_ficheiro(CONHECIMENTO_PL)

    perguntas = extrair_texto_pergunta(conteudo)
    motivos   = extrair_motivo_pergunta(conteudo)
    regras    = extrair_encaminhamentos(conteudo)

    regras_manuais = [r for r in regras if not e_regra_ml(r['justificacao'])]
    regras_ml      = [r for r in regras if e_regra_ml(r['justificacao'])]

    print(f"  → {len(perguntas)} sintomas/perguntas")
    print(f"  → {len(regras_manuais)} regras manuais (Parte A)")
    print(f"  → {len(regras_ml)} regras ML (Parte B)")

    texto = gerar_texto(perguntas, motivos, regras)

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(texto)

    print(f"  → Ficheiro gerado: {OUTPUT_FILE}")


if __name__ == '__main__':
    main()
