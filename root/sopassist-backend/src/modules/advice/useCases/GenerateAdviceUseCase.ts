import { MedicalDataRepository } from '../../medicalData/repositories/MedicalDataRepository';
import { PredictionRepository } from '../../prediction/repositories/PredictionRepository';
import { AppError } from '../../shared/errors/AppError';
import { AdviceRequestDTO, AdviceResponseDTO } from '../dtos/AdviceRequestDTO';
import AdviceService from '../services/AdiviceService';

export class GenerateAdviceUseCase {
  constructor(
    private medicalDataRepository: MedicalDataRepository,
    private predictionRepository: PredictionRepository,
    private adviceService: AdviceService
  ) {}

  async execute(patientId: string): Promise<AdviceResponseDTO> {
    const medicalData =
      await this.medicalDataRepository.findByPatientId(patientId);

    if (!medicalData) {
      throw new AppError('Medical data not found for the patient', 404);
    }

    const prediction =
      await this.predictionRepository.findLatestByPatientId(patientId);

    if (!prediction) {
      throw new AppError('Prediction data not found for the patient', 404);
    }

    const request: AdviceRequestDTO = {
      patientName: medicalData.patientId.name,
      medicalData: {
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
      },
      prediction: {
        result: prediction.predictionResult,
        confidenceScore: prediction.confidenceScore,
      },
    };

    return this.adviceService.generateAdvice(request);
  }
}

export default GenerateAdviceUseCase;
