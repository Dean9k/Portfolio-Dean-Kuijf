import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPRegressor
from sklearn.metrics import mean_absolute_error
import joblib

df = pd.read_csv("Airbnb_NYC_2019_VF.csv")

x = df[['room_type_Entire.home.apt', 'room_type_Private.room', 'room_type_Shared.room',
        'neighbourhood_group', 'number_of_reviews', 'availability_365',
        'minimum_nights', 'serious_crimes', 'attractions']]
y = df['price']

Xtr, Xts, ytr, yts = train_test_split(x, y, test_size=0.3, random_state=42)

nn = MLPRegressor(hidden_layer_sizes=[10,5,2], max_iter=900, random_state=42)
nn.fit(Xtr, ytr)

prev_nn = nn.predict(Xts)
mae_nn = mean_absolute_error(yts, prev_nn)
nnmae_nn = (mae_nn / (yts.max() - yts.min())) * 100

joblib.dump(nn, 'modelo.joblib')