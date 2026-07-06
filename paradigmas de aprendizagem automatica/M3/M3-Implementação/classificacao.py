import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.utils import resample
from sklearn.model_selection import StratifiedKFold
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import joblib
import warnings

warnings.filterwarnings("ignore")

df = pd.read_csv("Airbnb_NYC_2019_VF.csv")


def define_success(availability):
    q25 = availability.quantile(0.25)
    q75 = availability.quantile(0.75)
    if q25 == 0:
        q25 = availability[availability > 0].min()
    bins = [0, q25, q75, 365]
    labels = ['low', 'medium', 'high']
    return pd.cut(availability, bins=bins, labels=labels)

df["success"] = define_success(df["availability_365"])
df.dropna(subset=["success"], inplace=True)

le = LabelEncoder()
df["success"] = le.fit_transform(df["success"])
classes = le.classes_


df['interaction3'] = df['neighbourhood'] * df['minimum_nights']

X = df[['room_type_Entire.home.apt', 'room_type_Private.room',
        'room_type_Shared.room', 'neighbourhood', 'price',
        'minimum_nights', 'interaction3']]
y = df['success']

df_balanced = pd.concat([
    resample(df[df['success'] == label], 
             replace=True, 
             n_samples=5000, 
             random_state=42)
    for label in y.unique()
])

X_bal = df_balanced[X.columns].values
y_bal = df_balanced['success'].values

kf = StratifiedKFold(n_splits=10, shuffle=True, random_state=42)
accuracies = []

for train_idx, test_idx in kf.split(X_bal, y_bal):
    Xtr, Xts = X_bal[train_idx], X_bal[test_idx]
    ytr, yts = y_bal[train_idx], y_bal[test_idx]
    
    modelo_classificacao = DecisionTreeClassifier(max_depth=40, random_state=42)
    modelo_classificacao.fit(Xtr, ytr)
    
    pred = modelo_classificacao.predict(Xts)
    accuracies.append(accuracy_score(yts, pred))

joblib.dump(modelo_classificacao, 'modelo_classificacao.joblib')
joblib.dump(le, 'label_encoder_classificacao.joblib')
