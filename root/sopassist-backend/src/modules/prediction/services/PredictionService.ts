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
        cycle: data.cycle,
        amg: data.amg,
        weightGain: data.weightGain ? 1 : 0,
        hairLoss: data.hairLoss ? 1 : 0,
        darkeningSkin: data.darkeningSkin ? 1 : 0,
        pimple: data.pimple ? 1 : 0,
        fastFood: data.fastFood ? 1 : 0,
        leftFollicles: data.leftFollicles,
        rightFollicles: data.rightFollicles,
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
