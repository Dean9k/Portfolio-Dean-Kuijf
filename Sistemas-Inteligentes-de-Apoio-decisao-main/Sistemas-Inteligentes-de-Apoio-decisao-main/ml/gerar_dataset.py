#!/usr/bin/env python3

import pandas as pd
import numpy as np
import random
import os

random.seed(42)
np.random.seed(42)

FEATURES_TODOS = [
    'emergencia', 'doencas_cronicas', 'imunossuprimido'
]

FEATURES_RESPIRATORIO = [
    'sintomas_respiratorios', 'dormir_sentado', 'tosse_sangue',
    'pieira', 'inalador_sem_melhoria', 'pieira_intensa',
    'tosse_cronica', 'expectoracao_purulenta', 'estridor',
    'olfato_paladar', 'sintomas_gripais', 'saturacao_baixa',
    'cianose', 'inchaco_face_labios',
]

FEATURES_GASTRICO = [
    'febre', 'febre_nao_cede', 'febre_3_dias',
    'gastricos_prolongados', 'sinais_desidratacao', 'nauseas',
    'vomitos_sangue', 'fezes_escuras', 'dor_abdominal_intensa',
    'dor_abdominal_localizada', 'ictericia', 'problema_garganta',
    'dor_garganta_intensa', 'garganta_exsudados',
    'infecao_urinaria', 'infecao_urinaria_febre',
    'crianca_febril', 'mordedura_animal', 'dor_dental_intensa',
]

FEATURES_OUTROS = [
    'dor_peito_irradiada', 'dor_peito_repouso', 'palpitacoes_graves',
    'edema_membros', 'assimetria_facial_fala', 'fraqueza_unilateral',
    'cefaleia_subita', 'confusao_mental', 'rigidez_nuca',
    'erupcao_purpura', 'traumatismo_craniano', 'dor_costas_irradiada',
    'urina_sangue', 'dor_flanco', 'dor_articular', 'artrite_aguda',
    'olho_vermelho_dor', 'gravidez', 'gravidez_sangramento',
    'gravidez_dor', 'hipoglicemia', 'ansiedade_extrema',
]

# Lista completa (ordem consistente para o CSV)
FEATURES = FEATURES_TODOS + FEATURES_RESPIRATORIO + FEATURES_GASTRICO + FEATURES_OUTROS

FLUXO_FEATURES = {
    'respiratorio': FEATURES_TODOS + FEATURES_RESPIRATORIO,
    'febre_geral':  FEATURES_TODOS + FEATURES_GASTRICO,
    'outros':       FEATURES_TODOS + FEATURES_OUTROS,
}

CLASSES = [
    'emergencia_112',
    'urgencia_hospitalar',
    'consulta_medica',
    'contacto_sns24',
    'linha_saude_mental',
    'autocuidados_vigilancia',
    'autocuidados',
]

def encaminhar(s):
    # BLOCO A: EMERGÊNCIA 112
    if s['emergencia'] == 1:                                                          return 'emergencia_112'
    if s['assimetria_facial_fala'] == 1:                                              return 'emergencia_112'
    if s['dor_peito_irradiada'] == 1:                                                 return 'emergencia_112'
    if s['cianose'] == 1:                                                             return 'emergencia_112'
    if s['saturacao_baixa'] == 1:                                                     return 'emergencia_112'
    if s['cefaleia_subita'] == 1:                                                     return 'emergencia_112'
    if s['rigidez_nuca']==1 and s['confusao_mental']==1 and s['febre']==1:            return 'emergencia_112'
    if s['erupcao_purpura'] == 1:                                                     return 'emergencia_112'
    if s['crianca_febril'] == 1:                                                      return 'emergencia_112'
    if s['vomitos_sangue'] == 1:                                                      return 'emergencia_112'
    # BLOCO B: URGÊNCIA HOSPITALAR
    if s['sintomas_respiratorios']==1 and s['dormir_sentado']==1:                     return 'urgencia_hospitalar'
    if s['sintomas_respiratorios']==1 and s['tosse_sangue']==1:                       return 'urgencia_hospitalar'
    if s['sintomas_respiratorios']==1 and s['febre']==1 and s['pieira']==1 and s['inalador_sem_melhoria']==1: return 'urgencia_hospitalar'
    if s['pieira']==1 and s['pieira_intensa']==1 and s['inalador_sem_melhoria']==0:   return 'urgencia_hospitalar'
    if s['febre']==1 and s['imunossuprimido']==1:                                     return 'urgencia_hospitalar'
    if s['gastricos_prolongados']==1 and s['sinais_desidratacao']==1:                 return 'urgencia_hospitalar'
    if s['inchaco_face_labios']==1 and s['sintomas_respiratorios']==1:                return 'urgencia_hospitalar'
    if s['traumatismo_craniano'] == 1:                                                return 'urgencia_hospitalar'
    if s['dor_abdominal_intensa'] == 1:                                               return 'urgencia_hospitalar'
    if s['dor_abdominal_localizada']==1 and s['febre']==1:                            return 'urgencia_hospitalar'
    if s['estridor'] == 1:                                                            return 'urgencia_hospitalar'
    if s['palpitacoes_graves']==1 and s['sintomas_respiratorios']==1:                 return 'urgencia_hospitalar'
    if s['dor_peito_repouso'] == 1:                                                   return 'urgencia_hospitalar'
    if s['dor_flanco']==1 and s['febre']==1:                                          return 'urgencia_hospitalar'
    if s['artrite_aguda']==1 and s['febre']==1:                                       return 'urgencia_hospitalar'
    if s['olho_vermelho_dor'] == 1:                                                   return 'urgencia_hospitalar'
    if s['gravidez']==1 and s['gravidez_dor']==1:                                     return 'urgencia_hospitalar'
    if s['gravidez']==1 and s['gravidez_sangramento']==1:                             return 'urgencia_hospitalar'
    if s['urina_sangue']==1 and s['dor_flanco']==1:                                   return 'urgencia_hospitalar'
    if s['mordedura_animal']==1 and s['febre']==1:                                    return 'urgencia_hospitalar'
    if s['fezes_escuras'] == 1:                                                       return 'urgencia_hospitalar'
    if s['ictericia']==1 and s['febre']==1 and s['dor_abdominal_intensa']==1:         return 'urgencia_hospitalar'
    if s['dor_costas_irradiada']==1 and s['fraqueza_unilateral']==1:                  return 'urgencia_hospitalar'
    if s['edema_membros']==1 and s['dormir_sentado']==1:                              return 'urgencia_hospitalar'
    if s['dor_dental_intensa']==1 and s['febre']==1:                                  return 'urgencia_hospitalar'
    # BLOCO C: CONSULTA MÉDICA
    if s['febre']==1 and s['febre_nao_cede']==1:                                      return 'consulta_medica'
    if s['tosse_cronica']==1 and s['expectoracao_purulenta']==1:                      return 'consulta_medica'
    if s['garganta_exsudados']==1 and s['febre']==1:                                  return 'consulta_medica'
    if s['infecao_urinaria']==1 and s['infecao_urinaria_febre']==1:                   return 'consulta_medica'
    if s['dor_articular']==1 and s['artrite_aguda']==0 and s['febre']==0:             return 'consulta_medica'
    if s['dor_costas_irradiada']==1 and s['fraqueza_unilateral']==0:                  return 'consulta_medica'
    if s['ictericia']==1 and s['febre']==0:                                           return 'consulta_medica'
    # BLOCO D: CONTACTO SNS24
    if s['gastricos_prolongados']==1 and s['sinais_desidratacao']==0 and s['febre_3_dias']==1: return 'contacto_sns24'
    if s['febre']==1 and s['doencas_cronicas']==1:                                    return 'contacto_sns24'
    if s['infecao_urinaria']==1 and s['infecao_urinaria_febre']==0:                   return 'contacto_sns24'
    if s['sintomas_gripais']==1 and s['febre']==1 and s['doencas_cronicas']==1:       return 'contacto_sns24'
    if s['hipoglicemia']==1 and s['confusao_mental']==0:                              return 'contacto_sns24'
    # BLOCO E: SAÚDE MENTAL
    if s['ansiedade_extrema'] == 1:                                                   return 'linha_saude_mental'
    # BLOCO F: AUTOCUIDADOS VIGILÂNCIA
    if s['olfato_paladar'] == 1:                                                      return 'autocuidados_vigilancia'
    if s['sintomas_respiratorios']==1 and s['febre']==1 and s['olfato_paladar']==0:   return 'autocuidados_vigilancia'
    if s['sintomas_gripais']==1 and s['febre']==0:                                    return 'autocuidados_vigilancia'
    # BLOCO G: AUTOCUIDADOS
    return 'autocuidados'


def base():
    """Cria um registo com todos os sintomas a 0."""
    return {f: 0 for f in FEATURES}

def ruido_fluxo(s, fluxo, prob=0.12):
    """
    Adiciona ruído restrito às features do fluxo do exemplo.
    Garante que o encaminhamento esperado não é alterado.
    """
    destino_original = encaminhar(s)
    features_permitidas = FLUXO_FEATURES[fluxo]
    s_novo = s.copy()
    for feat in features_permitidas:
        if s_novo[feat] == 0 and random.random() < prob:
            s_novo[feat] = 1
            if encaminhar(s_novo) != destino_original:
                s_novo[feat] = 0
    return s_novo


print("=" * 60)
print("GERAÇÃO DO DATASET DE TREINO - SNS24")
print("=" * 60)
print(f"\nFeatures : {len(FEATURES)}")
print(f"Classes  : {len(CLASSES)}")
print()

registos = []

# ------------------------------------------------------------------
# EMERGÊNCIA 112 — fluxo variável (qualquer fluxo pode gerar emergência)
# ------------------------------------------------------------------
print("[1/7] A gerar exemplos de Emergência 112...")

# E1: Sinal geral — fluxo respiratório
for _ in range(40):
    s = base(); s['emergencia'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# E1: Sinal geral — fluxo gástrico
for _ in range(20):
    s = base(); s['emergencia'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

# E1: Sinal geral — fluxo outros
for _ in range(20):
    s = base(); s['emergencia'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# E2: AVC — fluxo outros
for _ in range(25):
    s = base()
    s['assimetria_facial_fala'] = 1
    s['fraqueza_unilateral'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'outros'))

# E3: Cianose — fluxo respiratório
for _ in range(20):
    s = base()
    s['cianose'] = 1
    s['sintomas_respiratorios'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'respiratorio'))

# E4: Saturação crítica — fluxo respiratório
for _ in range(20):
    s = base(); s['saturacao_baixa'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# E5: Cefaleia súbita — fluxo outros
for _ in range(20):
    s = base(); s['cefaleia_subita'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# E6: Meningite — fluxo outros
for _ in range(20):
    s = base()
    s['rigidez_nuca'] = 1; s['confusao_mental'] = 1; s['febre'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# E7: Púrpura — fluxo outros
for _ in range(15):
    s = base(); s['erupcao_purpura'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# E8: Bebé com febre — fluxo gástrico
for _ in range(20):
    s = base(); s['crianca_febril'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

# E9: Vómito de sangue — fluxo gástrico
for _ in range(20):
    s = base(); s['vomitos_sangue'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

print(f"   → {len(registos)} registos")

# ------------------------------------------------------------------
# URGÊNCIA HOSPITALAR
# ------------------------------------------------------------------
print("[2/7] A gerar exemplos de Urgência Hospitalar...")
n = len(registos)

# U1: Dificuldade resp. grave — fluxo respiratório
for _ in range(25):
    s = base()
    s['sintomas_respiratorios'] = 1; s['dormir_sentado'] = 1
    s['febre'] = random.randint(0, 1); s['pieira'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U2: Hemoptise — fluxo respiratório
for _ in range(20):
    s = base()
    s['sintomas_respiratorios'] = 1; s['tosse_sangue'] = 1
    s['dormir_sentado'] = 0; s['febre'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U3: Crise respiratória — fluxo respiratório
for _ in range(15):
    s = base()
    s['sintomas_respiratorios'] = 1; s['febre'] = 1
    s['pieira'] = 1; s['inalador_sem_melhoria'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U4: Pieira incapacitante — fluxo respiratório
for _ in range(20):
    s = base()
    s['pieira'] = 1; s['pieira_intensa'] = 1
    s['inalador_sem_melhoria'] = 0; s['sintomas_respiratorios'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U5: Imunossuprimido com febre — fluxo gástrico
for _ in range(15):
    s = base(); s['febre'] = 1; s['imunossuprimido'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

# U6: Desidratação grave — fluxo gástrico
for _ in range(15):
    s = base()
    s['gastricos_prolongados'] = 1; s['sinais_desidratacao'] = 1
    s['febre'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'febre_geral'))

# U7: Anafilaxia — fluxo respiratório
for _ in range(15):
    s = base()
    s['inchaco_face_labios'] = 1; s['sintomas_respiratorios'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U8: Traumatismo craniano — fluxo outros
for _ in range(20):
    s = base(); s['traumatismo_craniano'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U9: Abdómen agudo — fluxo gástrico
for _ in range(15):
    s = base(); s['dor_abdominal_intensa'] = 1
    s['febre'] = random.randint(0, 1); s['nauseas'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'febre_geral'))

# U10: Apendicite — fluxo gástrico
for _ in range(15):
    s = base()
    s['dor_abdominal_localizada'] = 1; s['febre'] = 1; s['nauseas'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

# U11: Estridor — fluxo respiratório
for _ in range(15):
    s = base(); s['estridor'] = 1
    registos.append(ruido_fluxo(s, 'respiratorio'))

# U12: Palpitações + dispneia — fluxo outros
for _ in range(15):
    s = base()
    s['palpitacoes_graves'] = 1; s['sintomas_respiratorios'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U13: Dor torácica repouso — fluxo outros
for _ in range(15):
    s = base(); s['dor_peito_repouso'] = 1; s['dor_peito_irradiada'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

# U14: Dor renal com febre — fluxo outros
for _ in range(15):
    s = base(); s['dor_flanco'] = 1; s['febre'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U15: Artrite séptica — fluxo outros
for _ in range(12):
    s = base(); s['artrite_aguda'] = 1; s['febre'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U16: Glaucoma — fluxo outros
for _ in range(12):
    s = base(); s['olho_vermelho_dor'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U17+18: Gravidez — fluxo outros
for _ in range(15):
    s = base(); s['gravidez'] = 1; s['gravidez_dor'] = 1
    registos.append(ruido_fluxo(s, 'outros'))
for _ in range(12):
    s = base(); s['gravidez'] = 1; s['gravidez_sangramento'] = 1; s['gravidez_dor'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

# U19: Hematúria — fluxo outros
for _ in range(12):
    s = base(); s['urina_sangue'] = 1; s['dor_flanco'] = 1
    registos.append(ruido_fluxo(s, 'outros'))

# U20: Mordedura com febre — fluxo gástrico
for _ in range(12):
    s = base(); s['mordedura_animal'] = 1; s['febre'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

# U21: Fezes escuras — fluxo gástrico
for _ in range(12):
    s = base(); s['fezes_escuras'] = 1
    registos.append(ruido_fluxo(s, 'febre_geral'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

# ------------------------------------------------------------------
# CONSULTA MÉDICA
# ------------------------------------------------------------------
print("[3/7] A gerar exemplos de Consulta Médica...")
n = len(registos)

# C1: Febre que não cede — fluxo gástrico
for _ in range(50):
    s = base(); s['febre'] = 1; s['febre_nao_cede'] = 1
    s['imunossuprimido'] = 0; s['sinais_desidratacao'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# C2: Tosse crónica — fluxo respiratório
for _ in range(25):
    s = base(); s['tosse_cronica'] = 1; s['expectoracao_purulenta'] = 1
    s['febre_nao_cede'] = 0
    registos.append(ruido_fluxo(s, 'respiratorio'))

# C3: Amigdalite — fluxo gástrico
for _ in range(25):
    s = base(); s['garganta_exsudados'] = 1; s['febre'] = 1; s['febre_nao_cede'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# C4: ITU com febre — fluxo gástrico
for _ in range(25):
    s = base(); s['infecao_urinaria'] = 1; s['infecao_urinaria_febre'] = 1; s['febre_nao_cede'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# C5: Dor articular sem inflamação — fluxo outros
for _ in range(15):
    s = base(); s['dor_articular'] = 1; s['artrite_aguda'] = 0; s['febre'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

# C6: Dor lombar sem fraqueza — fluxo outros
for _ in range(15):
    s = base(); s['dor_costas_irradiada'] = 1; s['fraqueza_unilateral'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

# C7: Icterícia sem febre — fluxo gástrico
for _ in range(15):
    s = base(); s['ictericia'] = 1; s['febre'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

# ------------------------------------------------------------------
# CONTACTO SNS24
# ------------------------------------------------------------------
print("[4/7] A gerar exemplos de Contacto SNS24...")
n = len(registos)

# S1: Gástricos + febre 3 dias — fluxo gástrico
for _ in range(35):
    s = base(); s['gastricos_prolongados'] = 1; s['sinais_desidratacao'] = 0
    s['febre_3_dias'] = 1; s['febre'] = random.randint(0, 1); s['imunossuprimido'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# S2: Grupo de risco com febre — fluxo gástrico
for _ in range(45):
    s = base(); s['febre'] = 1; s['doencas_cronicas'] = 1
    s['febre_nao_cede'] = 0; s['imunossuprimido'] = 0; s['sinais_desidratacao'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# S3: ITU simples — fluxo gástrico
for _ in range(25):
    s = base(); s['infecao_urinaria'] = 1; s['infecao_urinaria_febre'] = 0; s['febre'] = 0
    registos.append(ruido_fluxo(s, 'febre_geral'))

# S4: Gripais + risco — fluxo respiratório
for _ in range(25):
    s = base(); s['sintomas_gripais'] = 1; s['febre'] = 1; s['doencas_cronicas'] = 1
    s['febre_nao_cede'] = 0; s['imunossuprimido'] = 0
    registos.append(ruido_fluxo(s, 'respiratorio'))

# S5: Hipoglicemia — fluxo outros
for _ in range(15):
    s = base(); s['hipoglicemia'] = 1; s['confusao_mental'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

# ------------------------------------------------------------------
# LINHA SAÚDE MENTAL
# ------------------------------------------------------------------
print("[5/7] A gerar exemplos de Linha Saúde Mental...")
n = len(registos)

for _ in range(80):
    s = base(); s['ansiedade_extrema'] = 1; s['dor_peito_irradiada'] = 0
    registos.append(ruido_fluxo(s, 'outros'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

# ------------------------------------------------------------------
# AUTOCUIDADOS COM VIGILÂNCIA
# ------------------------------------------------------------------
print("[6/7] A gerar exemplos de Autocuidados com Vigilância...")
n = len(registos)

# V1: Olfato/paladar — fluxo respiratório
for _ in range(55):
    s = base(); s['olfato_paladar'] = 1; s['emergencia'] = 0
    s['febre'] = random.randint(0, 1); s['sintomas_respiratorios'] = random.randint(0, 1)
    s['febre_nao_cede'] = 0; s['doencas_cronicas'] = 0
    registos.append(ruido_fluxo(s, 'respiratorio'))

# V2: Resp + febre sem alarme — fluxo respiratório
for _ in range(55):
    s = base(); s['sintomas_respiratorios'] = 1; s['febre'] = 1
    s['olfato_paladar'] = 0; s['dormir_sentado'] = 0; s['tosse_sangue'] = 0
    s['pieira'] = 0; s['imunossuprimido'] = 0; s['febre_nao_cede'] = 0; s['doencas_cronicas'] = 0
    registos.append(ruido_fluxo(s, 'respiratorio'))

# V3: Gripais sem febre — fluxo respiratório
for _ in range(25):
    s = base(); s['sintomas_gripais'] = 1; s['febre'] = 0
    registos.append(ruido_fluxo(s, 'respiratorio'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

# ------------------------------------------------------------------
# AUTOCUIDADOS
# ------------------------------------------------------------------
print("[7/7] A gerar exemplos de Autocuidados...")
n = len(registos)

# Fluxo respiratório — sem sintomas relevantes
for _ in range(50):
    s = base(); s['emergencia'] = 0; s['sintomas_respiratorios'] = 0
    s['doencas_cronicas'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'respiratorio'))

# Fluxo gástrico — sem sintomas relevantes
for _ in range(50):
    s = base(); s['emergencia'] = 0; s['problema_garganta'] = 0; s['febre'] = 0
    s['doencas_cronicas'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'febre_geral'))

# Fluxo outros — sem sintomas relevantes
for _ in range(50):
    s = base(); s['emergencia'] = 0
    s['doencas_cronicas'] = random.randint(0, 1)
    registos.append(ruido_fluxo(s, 'outros'))

print(f"   → {len(registos) - n} registos ({len(registos)} total)")

print("\nA construir o DataFrame...")

df = pd.DataFrame(registos, columns=FEATURES)
df['destino'] = df.apply(encaminhar, axis=1)

assert df['destino'].isin(CLASSES).all(), "ERRO: Rótulos inválidos no dataset!"

print("\n" + "=" * 60)
print("RESUMO DO DATASET GERADO")
print("=" * 60)
print(f"\n  Total de exemplos : {len(df)}")
print(f"  Total de features : {len(FEATURES)}")
print(f"  Total de classes  : {len(CLASSES)}")
print(f"\n  Distribuição por classe:")

dist = df['destino'].value_counts()
for classe in CLASSES:
    count = dist.get(classe, 0)
    pct = count / len(df) * 100
    bar = '█' * int(pct / 2)
    print(f"    {classe:<30} {count:>4} ({pct:5.1f}%) {bar}")

print(f"\n  Densidade média de sintomas por registo:")
print(f"    {df[FEATURES].sum(axis=1).mean():.2f} sintomas ativos por exemplo")

SCRIPT_DIR  = os.path.dirname(os.path.abspath(__file__))
output_file = os.path.join(SCRIPT_DIR, '..', 'data', 'dataset_treino.csv')
df.to_csv(output_file, index=False)
print(f"\n✓ Dataset guardado em: {output_file}")
print(f"  Tamanho: {os.path.getsize(output_file) / 1024:.1f} KB")