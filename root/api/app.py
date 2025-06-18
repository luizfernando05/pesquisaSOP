from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd

app = Flask(__name__)
CORS(app)

model = joblib.load('model/rf_bests.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json

        required_fields = [
            "weight", "cycle", "amh", "weight_gain", "hair_growth", 
            "skin_darkening", "pimples", "fast_food", "follicleL", "follicleR"
        ]

        missing_fields = [field for field in required_fields if field not in data]

        if missing_fields:
            return jsonify({"error": f"Campos ausentes: {', '.join(missing_fields)}"}), 400

        features = [
            float(data["weight"]),
            int(data["cycle"]),
            float(data["amh"]),
            int(data["weight_gain"]),
            int(data["hair_growth"]),
            int(data["skin_darkening"]),
            int(data["pimples"]),
            int(data["fast_food"]),
            int(data["follicleL"]),
            int(data["follicleR"]),
        ]

        input_data = pd.DataFrame([features], columns=[
            'Weight (Kg)', 'Cycle(R/I)', 'AMH(ng/mL)', 'Weight gain(Y/N)',
            'hair growth(Y/N)', 'Skin darkening (Y/N)', 'Pimples(Y/N)',
            'Fast food (Y/N)', 'Follicle No. (L)', 'Follicle No. (R)'
        ])

        prediction = model.predict(input_data)[0]
        confidence_score = max(model.predict_proba(input_data)[0])

        return jsonify({
            "prediction_result": int(prediction),
            "confidence_score": round(confidence_score, 4)
        }), 200

    except ValueError:
        return jsonify({"error": "Erro ao converter os dados. Verifique os valores informados."}), 400
    except KeyError:
        return jsonify({"error": "Dados de entrada incorretos ou ausentes."}), 400
    except Exception as e:
        return jsonify({"error": f"Erro interno: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True)
