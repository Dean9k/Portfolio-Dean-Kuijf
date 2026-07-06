from flask import Flask, render_template, request
import pandas as pd
import joblib

app = Flask(__name__)

modelo_classificacao = joblib.load('modelo_classificacao.joblib')
label_encoder = joblib.load('label_encoder_classificacao.joblib')  

bairro_map = {'Kensington': 5.62695, 'Midtown': 3.454, 'Harlem': 2.91173, 'Clinton Hill': 4.44654, 'East Harlem': 3.77813, 'Murray Hill': 4.61122, 'Bedford-Stuyvesant': 2.5773, "Hell's Kitchen": 3.21724, 'Upper West Side': 3.21063, 'Chinatown': 4.88663, 'South Slope': 5.14494, 'West Village': 4.15234, 'Williamsburg': 2.52333, 'Fort Greene': 4.60303, 'Chelsea': 3.78172, 'Crown Heights': 3.44179, 'Park Slope': 4.56892, 'Windsor Terrace': 5.73484, 'Inwood': 5.26404, 'East Village': 3.27233, 'Greenpoint': 3.77992, 'Bushwick': 2.98708, 'Flatbush': 4.36449, 'Lower East Side': 3.98179, 'Prospect-Lefferts Gardens': 4.5133, 'Long Island City': 4.50957, 'Kips Bay': 4.64257, 'SoHo': 4.91411, 'Upper East Side': 3.30244, 'Prospect Heights': 4.9169, 'Washington Heights': 3.99504, 'Woodside': 5.3336, 'Brooklyn Heights': 5.75401, 'Carroll Gardens': 5.34211, 'Gowanus': 5.284, 'Flatlands': 6.36661, 'Cobble Hill': 6.19226, 'Flushing': 4.74065, 'Boerum Hill': 5.61565, 'Sunnyside': 4.90028, 'DUMBO': 7.18651, 'St. George': 6.90561, 'Highbridge': 7.46523, 'Financial District': 4.18405, 'Ridgewood': 4.7477, 'Morningside Heights': 4.94811, 'Jamaica': 5.35069, 'Middle Village': 7.33169, 'NoHo': 6.42798, 'Ditmars Steinway': 5.06086, 'Flatiron District': 6.40298, 'Roosevelt Island': 6.44072, 'Greenwich Village': 4.82362, 'Little Italy': 5.99341, 'East Flatbush': 4.58082, 'Tompkinsville': 7.03623, 'Astoria': 3.99393, 'Clason Point': 7.70639, 'Eastchester': 8.15837, 'Kingsbridge': 6.53475, 'Two Bridges': 6.50697, 'Queens Village': 6.68656, 'Rockaway Beach': 6.75438, 'Forest Hills': 5.8207, 'Nolita': 5.2601, 'Woodlawn': 8.31252, 'University Heights': 7.70639, 'Gravesend': 6.56332, 'Gramercy': 4.97143, 'Allerton': 7.03623, 'East New York': 5.40836, 'Theater District': 5.131, 'Concourse Village': 7.30092, 'Sheepshead Bay': 5.69148, 'Emerson Hill': 9.00567, 'Fort Hamilton': 6.77208, 'Bensonhurst': 6.4667, 'Tribeca': 5.61565, 'Shore Acres': 8.71799, 'Sunset Park': 4.82872, 'Concourse': 6.8656, 'Elmhurst': 5.32516, 'Brighton Beach': 6.4667, 'Jackson Heights': 5.56632, 'Cypress Hills': 5.88478, 'St. Albans': 6.45362, 'Arrochar': 7.70639, 'Rego Park': 6.1246, 'Wakefield': 6.8656, 'Clifton': 8.02484, 'Bay Ridge': 5.8416, 'Graniteville': 9.41114, 'Spuyten Duyvil': 9.18799, 'Stapleton': 7.46523, 'Briarwood': 6.75438, 'Ozone Park': 6.6543, 'Columbia St': 7.03623, 'Vinegar Hill': 7.24208, 'Mott Haven': 6.68656, 'Longwood': 6.6543, 'Canarsie': 5.80022, 'Battery Park City': 6.53475, 'Civic Center': 6.82714, 'East Elmhurst': 5.57168, 'New Springville': 8.60021, 'Morris Heights': 7.90706, 'Arverne': 6.44072, 'Cambria Heights': 7.50159, 'Tottenville': 8.71799, 'Mariners Harbor': 8.60021, 'Concord': 7.50159, 'Borough Park': 5.87745, 'Bayside': 7.10855, 'Downtown Brooklyn': 6.36661, 'Port Morris': 6.94728, 'Fieldston': 8.23248, 'Kew Gardens': 7.30092, 'Midwood': 6.09695, 'College Point': 7.8017, 'Mount Eden': 8.85152, 'City Island': 7.85299, 'Glendale': 6.7901, 'Port Richmond': 8.49485, 'Red Hook': 6.4154, 'Richmond Hill': 6.24355, 'Bellerose': 8.08938, 'Maspeth': 6.0879, 'Williamsbridge': 7.08386, 'Soundview': 8.02484, 'Woodhaven': 6.30879, 'Woodrow': 10.10428, 'Co-op City': 9.69882, 'Stuyvesant Town': 7.15984, 'Parkchester': 7.10855, 'North Riverdale': 8.39954, 'Dyker Heights': 8.23248, 'Bronxdale': 7.8017, 'Sea Gate': 8.71799, 'Riverdale': 8.31252, 'Kew Gardens Hills': 7.50159, 'Bay Terrace': 8.85152, 'Norwood': 7.33169, 'Claremont Village': 7.43013, 'Whitestone': 8.31252, 'Fordham': 6.63855, 'Bayswater': 7.90706, 'Navy Yard': 8.08938, 'Brownsville': 6.6703, 'Eltingville': 9.41114, 'Fresh Meadows': 7.30092, 'Mount Hope': 7.75291, 'Lighthouse Hill': 9.69882, 'Springfield Gardens': 6.34308, 'Howard Beach': 7.75291, 'Belle Harbor': 8.60021, 'Jamaica Estates': 7.8017, 'Van Nest': 8.31252, 'Morris Park': 8.02484, 'West Brighton': 7.85299, 'Far Rockaway': 7.39623, 'South Ozone Park': 7.08386, 'Tremont': 8.31252, 'Corona': 6.62304, 'Great Kills': 8.39954, 'Manhattan Beach': 8.60021, 'Marble Hill': 8.23248, 'Dongan Hills': 8.71799, 'Castleton Corners': 9.18799, 'East Morrisania': 8.39954, 'Hunts Point': 7.85299, 'Neponsit': 9.41114, 'Pelham Bay': 7.90706, 'Randall Manor': 7.8017, 'Throgs Neck': 7.57855, 'Todt Hill': 9.18799, 'West Farms': 9.69882, 'Silver Lake': 9.69882, 'Morrisania': 7.85299, 'Laurelton': 7.85299, 'Grymes Hill': 8.71799, 'Holliswood': 9.18799, 'Pelham Gardens': 7.43013, 'Belmont': 7.57855, 'Rosedale': 6.70309, 'Edgemere': 8.31252, 'New Brighton': 9.00567, 'Midland Beach': 8.85152, 'Baychester': 8.71799, 'Melrose': 8.39954, 'Bergen Beach': 8.39954, 'Richmondtown': 10.10428, 'Howland Hook': 9.69882, 'Schuylerville': 8.15837, 'Coney Island': 7.90706, 'New Dorp Beach': 9.00567, "Prince's Bay": 9.18799, 'South Beach': 8.60021, 'Bath Beach': 7.90706, 'Jamaica Hills': 8.60021, 'Oakwood': 9.00567, 'Castle Hill': 8.49485, 'Hollis': 8.08938, 'Douglaston': 8.60021, 'Huguenot': 9.41114, 'Olinville': 9.18799, 'Edenwald': 8.15837, 'Grant City': 8.85152, 'Westerleigh': 9.69882, 'Bay Terrace, Staten Island': 9.69882, 'Westchester Square': 8.39954, 'Little Neck': 9.00567, 'Fort Wadsworth': 10.10428, 'Rosebank': 8.71799, 'Unionport': 8.71799, 'Mill Basin': 9.18799, 'Arden Heights': 9.18799, "Bull's Head": 8.85152, 'New Dorp': 10.10428, 'Rossville': 10.10428, 'Breezy Point': 9.41114, 'Willowbrook': 10.10428}

@app.route('/', methods=['GET', 'POST'])
def index():
    valores_padrao = {
        'room_type_Entire.home.apt': '0',
        'room_type_Private.room': '0',
        'room_type_Shared.room': '0',
        'neighbourhood_group': 'Manhattan',
        'price': '0',
        'minimum_nights': '0'
    }

    if request.method == 'POST':
        try:
            tipo_quarto = request.form.get('tipo_quarto')
            dados = {}
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
            bairro_valor = bairro_map[bairro]
            dados['neighbourhood'] = [bairro_valor]

            preco = float(request.form.get('price'))
            noites = float(request.form.get('minimum_nights'))

            dados['price'] = [preco]
            dados['minimum_nights'] = [noites]
            dados['interaction3'] = [bairro_valor * noites]

            df = pd.DataFrame(dados)

            pred_classe = modelo_classificacao.predict(df)[0]
            sucesso_str = label_encoder.inverse_transform([pred_classe])[0]

            return render_template('index_c.html',
                                   valores_padrao=valores_padrao,
                                   resultado=f'Predicted Success: {sucesso_str.capitalize()}')
        

        except Exception as e:
            print("Erro:", str(e))
            return render_template('index_c.html',
                                   valores_padrao=valores_padrao,
                                   mensagem_erro='Error. Please check the data entered.')

    return render_template('index_c.html', valores_padrao=valores_padrao)

if __name__ == '__main__':
    app.run(debug=True)
