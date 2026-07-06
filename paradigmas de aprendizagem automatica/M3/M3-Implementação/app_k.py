from flask import Flask, render_template, request
import joblib
import numpy as np

app = Flask(__name__)

limit_price = joblib.load('limite_preco.joblib')

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            preco = float(request.form['preco'])
            noites = int(request.form['noites'])

            if preco <= limit_price:
                resultado = 'Economic'
            else:
                resultado = 'Premium'

            return render_template('index_k.html', resultado=resultado)
        except:
            return render_template('index_k.html', erro="Erro nos dados inseridos.")

    return render_template('index_k.html')

if __name__ == '__main__':
    app.run(debug=True)