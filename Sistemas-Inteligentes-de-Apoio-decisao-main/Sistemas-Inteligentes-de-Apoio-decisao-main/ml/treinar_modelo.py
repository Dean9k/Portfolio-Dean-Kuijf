# Treina modelo ML (Árvore de Decisão) e injeta regras em conhecimento.pl
# Lê dataset → treina → gera regras Prolog → substitui bloco ML anterior.

import pandas as pd
import numpy as np
import json
import os
import re
import shutil
import subprocess
from collections import defaultdict
from sklearn.tree import DecisionTreeClassifier, plot_tree, _tree
from sklearn.model_selection import train_test_split, RandomizedSearchCV
from sklearn.metrics import (classification_report, accuracy_score,
                             confusion_matrix, ConfusionMatrixDisplay)
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# CONFIGURAÇÃO DE CAMINHOS
SCRIPT_DIR       = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR      = os.path.join(SCRIPT_DIR, '..', 'backend')
DATASET_FILE     = os.path.join(SCRIPT_DIR, '..', 'data', 'dataset_treino.csv')
CONHECIMENTO_PL  = os.path.join(BACKEND_DIR, 'conhecimento.pl')
IMG_OUTPUT_DIR   = os.path.join(SCRIPT_DIR, 'metricas_img')
METRICAS_JSON    = os.path.join(SCRIPT_DIR, 'metricas_ml.json')

# Marcadores que delimitam o bloco ML dentro do conhecimento.pl
MARKER_START = "% === INICIO REGRAS PARTE B (geradas por ML) ==="
MARKER_END   = "% === FIM REGRAS PARTE B (geradas por ML) ==="

os.makedirs(IMG_OUTPUT_DIR, exist_ok=True)

if not os.path.exists(DATASET_FILE):
    print(f"ERRO: Dataset nao encontrado")
    exit(1)

df = pd.read_csv(DATASET_FILE)

if 'destino' not in df.columns or len(df) < 10:
    print("ERRO: Dataset vazio ou sem cabeçalho")
    exit(1)

print(f"Dataset: {len(df)} exemplos")

FEATURES = [c for c in df.columns if c != 'destino']
CLASSES_ORDEM = [
    'emergencia_112', 'urgencia_hospitalar', 'consulta_medica',
    'contacto_sns24', 'linha_saude_mental', 'autocuidados_vigilancia',
    'autocuidados']

X = df[FEATURES]
y = df['destino']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)

# Otimiza pesos das classes (emergencia_112, urgencia_hospitalar e contacto_sns24 tinham mais erros)
peso_opcoes = [1, 1.5, 2, 2.5, 3]
param_dist = {
    'class_weight': [
        {'emergencia_112': e, 'urgencia_hospitalar': u, 'consulta_medica': c,
         'contacto_sns24': s, 'linha_saude_mental': l,
         'autocuidados_vigilancia': av, 'autocuidados': a}
        for e in peso_opcoes for u in [1, 1.5] for c in [1, 1.5]
        for s in peso_opcoes for l in [1, 2] for av in [1] for a in [1]
    ]
}

print(f"Testando {len(param_dist['class_weight'])} combinações de pesos...")

base_clf = DecisionTreeClassifier(
    max_depth=20, min_samples_leaf=3, min_samples_split=6,
    criterion='gini', random_state=42)

search = RandomizedSearchCV(
    base_clf, param_dist, n_iter=80, cv=5,
    scoring='balanced_accuracy', random_state=42, n_jobs=-1, verbose=1)
search.fit(X_train, y_train)

clf = search.best_estimator_
clf.fit(X_train, y_train)

y_pred = clf.predict(X_test)
acc = accuracy_score(y_test, y_pred)

print(f"Accuracy: {acc*100:.1f}% | Profundidade: {clf.get_depth()} | Folhas: {clf.get_n_leaves()}")
print(f"\n  Relatório de Classificação:")
print(classification_report(y_test, y_pred, zero_division=0))

# 3. EXTRAÇÃO DE REGRAS PROLOG
print(f"\n[3/5] A extrair regras Prolog da árvore...")

def tree_to_prolog(clf, feature_names, class_names):
    tree_ = clf.tree_
    rules = []

    def recurse(node, conditions):
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            feat = feature_names[tree_.feature[node]]
            recurse(tree_.children_left[node],  conditions + [('negativo', feat)])
            recurse(tree_.children_right[node], conditions + [('exato',    feat)])
        else:
            total      = int(tree_.n_node_samples[node])
            values     = tree_.value[node][0]
            class_idx  = int(np.argmax(values))
            class_name = class_names[class_idx]
            confidence = float(values[class_idx]) / float(sum(values)) if sum(values) > 0 else 0
            if total >= 3 and confidence >= 0.60:
                rules.append((conditions[:], class_name, confidence, total))

    recurse(0, [])
    return rules

class_names = [str(c) for c in clf.classes_]
rules       = tree_to_prolog(clf, FEATURES, class_names)
print(f"  Total de regras extraídas: {len(rules)}")

# 4. GERAÇÃO DO BLOCO PROLOG E INJEÇÃO NO conhecimento.pl
#    Regras usam verifica_exato/3 e verifica_negativo/3 do motor.pl,
#    exatamente como as regras manuais da Parte A.
print(f"\n[4/5] A injetar regras em conhecimento.pl...")

JUSTIFICACOES = {
    'emergencia_112':         'ML: Padrao de sintomas indica emergencia vital - ativar 112.',
    'urgencia_hospitalar':    'ML: Padrao de sintomas requer avaliacao urgente em hospital.',
    'consulta_medica':        'ML: Padrao de sintomas requer consulta medica presencial.',
    'contacto_sns24':         'ML: Padrao de sintomas requer contacto com SNS24.',
    'linha_saude_mental':     'ML: Padrao de sintomas sugere apoio psicologico SNS24.',
    'autocuidados_vigilancia':'ML: Padrao de sintomas sugere autocuidados com vigilancia.',
    'autocuidados':           'ML: Padrao de sintomas indica tratamento em casa.',
}
CF_BASE = {
    'emergencia_112':         1.00,
    'urgencia_hospitalar':    0.92,
    'consulta_medica':        0.82,
    'contacto_sns24':         0.75,
    'linha_saude_mental':     0.85,
    'autocuidados_vigilancia':0.65,
    'autocuidados':           0.55,
}

# Agrupa e ordena regras por classe (maior confiança primeiro)
regras_por_classe = defaultdict(list)
for conds, classe, conf, suporte in rules:
    regras_por_classe[classe].append((conds, conf, suporte))
for classe in regras_por_classe:
    regras_por_classe[classe].sort(key=lambda x: (-x[1], -x[2]))

# Constrói bloco Prolog com as regras ML para injetar em conhecimento.pl
def build_prolog_block(regras_por_classe, acc, n_rules):
    linhas = []
    linhas.append("")
    linhas.append("")
    linhas.append(MARKER_START)
    linhas.append(f"% Arvore de Decisao (scikit-learn) | {n_rules} regras | Accuracy: {acc*100:.1f}%")
    linhas.append("% FICHEIRO GERADO AUTOMATICAMENTE — NAO EDITAR MANUALMENTE")
    linhas.append("")
    linhas.append("")

    rule_counter = 0
    for classe in CLASSES_ORDEM:
        if classe not in regras_por_classe:
            continue
        linhas.append(f"% --- {classe.upper().replace('_', ' ')} (ML) ---")
        for conds, conf, suporte in regras_por_classe[classe]:
            rule_counter += 1
            cf_val = round(CF_BASE[classe] * conf, 3)
            justif = JUSTIFICACOES[classe]
            linhas.append(f"% Regra ML #{rule_counter} (suporte:{suporte}, confianca:{conf:.2f})")
            linhas.append(f"encaminhamento({classe}, '{justif}', CF_Final) :-")

            body_lines = []
            cf_vars    = []
            for i, (tipo, feat) in enumerate(conds):
                var = f"CF_{i}"
                cf_vars.append(var)
                if tipo == 'exato':
                    body_lines.append(f"    verifica_exato(sintoma, {feat}, {var})")
                else:
                    body_lines.append(f"    verifica_negativo(sintoma, {feat}, {var})")

            if cf_vars:
                if len(cf_vars) == 1:
                    body_lines.append(f"    CF_Premissa = {cf_vars[0]}")
                else:
                    body_lines.append(f"    minimo({cf_vars[0]}, {cf_vars[1]}, T0)")
                    for k in range(2, len(cf_vars)):
                        body_lines.append(f"    minimo(T{k-2}, {cf_vars[k]}, T{k-1})")
                    body_lines.append(f"    CF_Premissa = T{len(cf_vars)-2}")
                body_lines.append(f"    CF_Premissa >= 0.5")
                body_lines.append(f"    CF_Regra = {cf_val}")
                body_lines.append(f"    CF_Final is CF_Premissa * CF_Regra")
            else:
                body_lines.append(f"    CF_Final = {cf_val}")

            linhas.append(",\n".join(body_lines) + ".")
            linhas.append("")

    linhas.append(MARKER_END)
    return "\n".join(linhas), rule_counter

novo_bloco, rule_counter = build_prolog_block(regras_por_classe, acc, len(rules))

# Lê conhecimento.pl para inserir bloco ML
if not os.path.exists(CONHECIMENTO_PL):
    print(f"\nERRO: Ficheiro não encontrado: {CONHECIMENTO_PL}")
    exit(1)

with open(CONHECIMENTO_PL, 'r', encoding='utf-8') as f:
    conteudo_atual = f.read()

# Backup antes de modificar
shutil.copy(CONHECIMENTO_PL, CONHECIMENTO_PL + '.bak')

# Substitui bloco ML anterior ou acrescenta no fim
if MARKER_START in conteudo_atual:
    # Encontrou bloco anterior, substitui
    padrao = re.compile(
        r'\n?' + re.escape(MARKER_START) + r'.*?' + re.escape(MARKER_END),
        re.DOTALL
    )
    conteudo_novo = padrao.sub(novo_bloco, conteudo_atual)
else:
    conteudo_novo = conteudo_atual.rstrip() + "\n" + novo_bloco + "\n"

with open(CONHECIMENTO_PL, 'w', encoding='utf-8') as f:
    f.write(conteudo_novo)

print(f"Regras injetadas: {rule_counter}")

CORES = {
    'emergencia_112':         '#d62728',
    'urgencia_hospitalar':    '#ff7f0e',
    'consulta_medica':        '#1f77b4',
    'contacto_sns24':         '#9467bd',
    'linha_saude_mental':     '#e377c2',
    'autocuidados_vigilancia':'#2ca02c',
    'autocuidados':           '#17becf',
}
LABELS_PT = {
    'emergencia_112':         'Emergência 112',
    'urgencia_hospitalar':    'Urgência Hospitalar',
    'consulta_medica':        'Consulta Médica',
    'contacto_sns24':         'Contacto SNS24',
    'linha_saude_mental':     'Linha Saúde Mental',
    'autocuidados_vigilancia':'Autocuidados c/ Vigilância',
    'autocuidados':           'Autocuidados',
}

dist_full  = y.value_counts()
classes_ord = [c for c in CLASSES_ORDEM if c in dist_full.index]
contagens   = [dist_full[c] for c in classes_ord]
cores_ord   = [CORES[c] for c in classes_ord]
labels_ord  = [LABELS_PT[c] for c in classes_ord]

# Gráfico 1: Distribuição do dataset
fig, ax = plt.subplots(figsize=(9, 5))
bars = ax.barh(labels_ord, contagens, color=cores_ord, edgecolor='white', height=0.6)
ax.bar_label(bars, fmt='%d', padding=4, fontsize=11, fontweight='bold')
ax.set_xlabel('Número de instâncias', fontsize=12)
ax.set_title('Distribuição do Dataset de Treino por Classe', fontsize=14, fontweight='bold', pad=15)
ax.set_xlim(0, max(contagens) * 1.15)
ax.spines['top'].set_visible(False); ax.spines['right'].set_visible(False)
ax.invert_yaxis()
plt.tight_layout()
plt.savefig(os.path.join(IMG_OUTPUT_DIR, 'grafico_distribuicao.png'), dpi=150, bbox_inches='tight')
plt.close()

# Gráfico 2: Importância das features
imp_dict   = dict(zip(FEATURES, clf.feature_importances_))
imp_sorted = [(f, v) for f, v in sorted(imp_dict.items(), key=lambda x: x[1]) if v > 0]
feats      = [f.replace('_', ' ') for f, _ in imp_sorted]
vals       = [v for _, v in imp_sorted]
cores_imp  = ['#d62728' if v == max(vals) else '#1f77b4' for v in vals]

fig, ax = plt.subplots(figsize=(9, max(5, len(feats) * 0.4)))
bars = ax.barh(feats, vals, color=cores_imp, edgecolor='white', height=0.6)
ax.bar_label(bars, fmt='%.3f', padding=4, fontsize=9)
ax.set_xlabel('Importância (Gini)', fontsize=12)
ax.set_title('Importância das Features na Árvore de Decisão', fontsize=14, fontweight='bold', pad=15)
ax.set_xlim(0, max(vals) * 1.2)
ax.spines['top'].set_visible(False); ax.spines['right'].set_visible(False)
plt.tight_layout()
plt.savefig(os.path.join(IMG_OUTPUT_DIR, 'grafico_importancias.png'), dpi=150, bbox_inches='tight')
plt.close()

# Gráfico 3: Matriz de confusão
classes_disp = [LABELS_PT.get(c, c) for c in clf.classes_]
cm           = confusion_matrix(y_test, y_pred, labels=clf.classes_)
fig, ax      = plt.subplots(figsize=(9, 7))
disp         = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=classes_disp)
disp.plot(ax=ax, colorbar=True, cmap='Blues', xticks_rotation=30)
ax.set_title('Matriz de Confusão — Conjunto de Teste', fontsize=14, fontweight='bold', pad=15)
plt.tight_layout()
plt.savefig(os.path.join(IMG_OUTPUT_DIR, 'grafico_matriz_confusao.png'), dpi=150, bbox_inches='tight')
plt.close()

# Gráfico 4: Árvore de decisão
fig, ax = plt.subplots(figsize=(28, 12))
plot_tree(clf,
    feature_names=[f.replace('_', '\n') for f in FEATURES],
    class_names=[LABELS_PT.get(c, c) for c in clf.classes_],
    filled=True, rounded=True, fontsize=7, ax=ax,
    impurity=False, proportion=False)
ax.set_title('Árvore de Decisão — Sistema de Triagem SNS24', fontsize=16, fontweight='bold', pad=20)
plt.tight_layout()
plt.savefig(os.path.join(IMG_OUTPUT_DIR, 'arvore_decisao.png'), dpi=150, bbox_inches='tight')
plt.close()

print(f"  → {IMG_OUTPUT_DIR}/ (4 gráficos)")

# Guardar métricas JSON
report   = classification_report(y_test, y_pred, output_dict=True, zero_division=0)
metricas = {
    'accuracy':     round(acc * 100, 1),
    'n_exemplos':   int(len(df)),
    'n_regras':     rule_counter,
    'n_features':   len(FEATURES),
    'classes':      CLASSES_ORDEM,
    'distribuicao': {k: int(v) for k, v in dist_full.items()},
    'report':       report,
    'features':     FEATURES,
    'importancias': {f: round(float(v), 4) for f, v in zip(FEATURES, clf.feature_importances_)},
    'tree_depth':   int(clf.get_depth()),
    'tree_leaves':  int(clf.get_n_leaves()),
}
with open(METRICAS_JSON, 'w', encoding='utf-8') as f:
    json.dump(metricas, f, ensure_ascii=False, indent=2)
# Copia também para backend/ para o servidor Prolog poder servir via API
shutil.copy(METRICAS_JSON, os.path.join(BACKEND_DIR, 'metricas_ml.json'))
print(f"  → metricas_ml.json")

# Recompila conhecimento.pl → .qlf para que o próximo arranque do servidor seja mais rápido
print("A recompilar conhecimento.qlf...", end=' ', flush=True)
qlf_result = subprocess.run(
    ['swipl', '-g', "qcompile('conhecimento.pl'),halt"],
    cwd=BACKEND_DIR, capture_output=True, text=True
)
if qlf_result.returncode == 0:
    print("OK")
else:
    print(f"AVISO: {qlf_result.stderr.strip() or 'falhou'}")

# RESUMO FINAL
print(f"\n{'=' * 60}")
print("RESUMO FINAL")
print(f"{'=' * 60}")
print(f"  Dataset              : {len(df)} exemplos")
print(f"  Accuracy (teste)     : {acc*100:.1f}%")
print(f"  Regras ML injetadas  : {rule_counter} → backend/conhecimento.pl")
print(f"  Profundidade árvore  : {clf.get_depth()} níveis")
print(f"\n  Top 5 features mais importantes:")
top5 = sorted(zip(FEATURES, clf.feature_importances_), key=lambda x: -x[1])[:5]
for feat, imp in top5:
    print(f"    {feat:<30} {imp:.4f}  {'█' * int(imp * 40)}")
print(f"\n✓ Concluído! Regras ML adicionadas diretamente ao conhecimento.pl.")
print(f"  Podes agora eliminar o ficheiro conhecimento_ml.pl.")