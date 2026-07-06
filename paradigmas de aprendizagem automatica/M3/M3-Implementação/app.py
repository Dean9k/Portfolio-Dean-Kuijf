from flask import Flask, render_template, request
import pandas as pd
import joblib

app = Flask(__name__)

modelo = joblib.load('modelo.joblib')

bairro_map = {
    'Manhattan': 0.81412,
    'Brooklyn': 0.88871,
    'Queens': 2.15502,
    'Bronx': 3.80166,
    'Staten Island': 4.87317
}

@app.route('/', methods=['GET', 'POST'])
def index():
    valores_padrao = {
        'room_type_Entire.home.apt': '0',
        'room_type_Private.room': '0',
        'room_type_Shared.room': '0',
        'neighbourhood_group': 'Manhattan',
        'number_of_reviews': '0',
        'availability_365': '0',
        'minimum_nights': '0',
        'serious_crimes': '0',
        'attractions': '0'
    }
    
    if request.method == 'POST':
        try:
            dados = {}

            tipo_quarto = request.form.get('tipo_quarto')
            if tipo_quarto == 'Entire home/apt':
                dados['room_type_Entire.home.apt'] = [1.0]
                dados['room_type_Private.room'] = [0.0]
                dados['room_type_Shared.room'] = [0.0]
            elif tipo_quarto == 'Private room':
                dados['room_type_Entire.home.apt'] = [0.0]
                dados['room_type_Private.room'] = [1.0]
                dados['room_type_Shared.room'] = [0.0]
            else:
                dados['room_type_Entire.home.apt'] = [0.0]
                dados['room_type_Private.room'] = [0.0]
                dados['room_type_Shared.room'] = [1.0]

            bairro = request.form.get('bairro')
            dados['neighbourhood_group'] = [bairro_map[bairro]]
            dados['number_of_reviews'] = [float(request.form.get('numero_avaliacoes', 0))]
            dados['availability_365'] = [float(request.form.get('disponibilidade', 0))]
            dados['minimum_nights'] = [float(request.form.get('noites_minimas', 0))]
            dados['serious_crimes'] = [float(request.form.get('crimes_graves', 0))]
            dados['attractions'] = [float(request.form.get('atracoes', 0))]

            df_predicao = pd.DataFrame(dados)
            preco_previsto = modelo.predict(df_predicao)[0]

            return render_template(
                'index.html',
                valores_padrao=valores_padrao,
                preco_previsto=f'${preco_previsto:.2f}',
                mensagem_status="Prediction successfully accomplished!"
            )
        except Exception:
            return render_template(
                'index.html',
                valores_padrao=valores_padrao,
                mensagem_erro="Error. Please check the data entered."
            )

    return render_template('index.html', valores_padrao=valores_padrao)

if __name__ == '__main__':
    app.run(debug=True)
