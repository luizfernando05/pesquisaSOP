import axios from 'axios';
import { AppError } from '../../shared/errors/AppError';
import {
  PredictionRequestDTO,
  PredictionResponseDTO,
} from '../dto/PredictionRequestDTO';

export class PredictionService {
  private apiUrl: string;

  constructor() {
    this.apiUrl = process.env.FLASK_API_URL || 'http://localhost:5000';
  }

  async predict(data: PredictionRequestDTO): Promise<PredictionResponseDTO> {
    try {
      const transformedData = {
        weight: data.weight,
        cycle: data.cycle ? 4 : 2,
        amh: data.amg,
        weight_gain: data.weightGain ? 1 : 0,
        hair_growth: data.hairLoss ? 1 : 0,
        skin_darkening: data.darkeningSkin ? 1 : 0,
        pimples: data.pimple ? 1 : 0,
        fast_food: data.fastFood ? 1 : 0,
        follicleL: data.leftFollicles,
        follicleR: data.rightFollicles,
      };

      const response = await axios.post(
        `${this.apiUrl}/predict`,
        transformedData
      );

      const flaskResponse = response.data;

      const mappedResponse: PredictionResponseDTO = {
        predictionResult: flaskResponse.prediction_result,
        confidenceScore: flaskResponse.confidence_score,
      };

      return mappedResponse;
    } catch (err) {
      throw new AppError('Error communicating with prediction API', 500);
    }
  }
}

export default PredictionService;
