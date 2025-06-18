import Prediction from '../../../domain/entities/Prediction';
import { IMedicalDataRepository } from '../../medicalData/interfaces/IMedicalDataRepository';
import { AppError } from '../../shared/errors/AppError';
import { IUserRepository } from '../../users/interfaces/IUserRepository';
import { PredictionResponseDTO } from '../dto/PredictionRequestDTO';
import { IPredictionRepository } from '../interfaces/IPredictionRepository';
import PredictionService from '../services/PredictionService';

export class PredictUseCase {
  constructor(
    private predictionService: PredictionService,
    private predictionRepository: IPredictionRepository,
    private medicalDataRepository: IMedicalDataRepository,
    private userRepository: IUserRepository
  ) {}

  async execute({
    patientId,
  }: {
    patientId: string;
  }): Promise<PredictionResponseDTO> {
    const patient = await this.userRepository.findById(patientId);
    if (!patient) {
      throw new AppError('Patient not found', 404);
    }

    const medicalData =
      await this.medicalDataRepository.findByPatientId(patientId);
    if (!medicalData) {
      throw new AppError('Medical data not found for the patient', 404);
    }

    const predictionData = {
      weight: medicalData.weight,
      cycle: medicalData.cycle,
      amg: medicalData.amg,
      weightGain: medicalData.weightGain,
      hairLoss: medicalData.hairLoss,
      darkeningSkin: medicalData.darkeningSkin,
      pimple: medicalData.pimple,
      fastFood: medicalData.fastFood,
      leftFollicles: medicalData.leftFollicles,
      rightFollicles: medicalData.rightFollicles,
    };

    const predictionResponse =
      await this.predictionService.predict(predictionData);

    const prediction = new Prediction();
    prediction.patient = { id: patientId } as any;
    prediction.predictionResult = predictionResponse.predictionResult;
    prediction.confidenceScore = predictionResponse.confidenceScore;

    await this.predictionRepository.create(prediction);

    return predictionResponse;
  }
}

export default PredictUseCase;
