import pandas as pd
from sklearn.cluster import KMeans
import joblib

df = pd.read_csv("Airbnb_NYC_2019_VF.csv")

X = df[['price', 'minimum_nights']]

kmeans = KMeans(n_clusters=2, random_state=42)
kmeans.fit(X)

centroides = kmeans.cluster_centers_
limit_price = (centroides[0][0] + centroides[1][0]) / 2

joblib.dump(limit_price, 'limite_preco.joblib')