import { NextFunction, Request, Response } from 'express';
import PredictUseCase from '../useCase/PredictUseCase';
import PredictionService from '../services/PredictionService';
import { PredictionRepository } from '../repositories/PredictionRepository';
import { MedicalDataRepository } from '../../medicalData/repositories/MedicalDataRepository';
import { UserRepository } from '../../users/repositories/UserRepository';

export class PredictionController {
  async handle(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<Response | void> {
    try {
      const patientId = req.user?.id;

      const predictUseCase = new PredictUseCase(
        new PredictionService(),
        new PredictionRepository(),
        new MedicalDataRepository(),
        new UserRepository()
      );

      const result = await predictUseCase.execute({ patientId });

      const predictionLabels: { [key: number]: string } = {
        0: 'Positive',
        1: 'Negative',
      };

      return res.status(200).json({
        predictionResult:
          predictionLabels[Number(result.predictionResult)] || 'Unknown',
        confidenceScore: result.confidenceScore,
      });
    } catch (err) {
      next(err);
    }
  }
}

export default PredictionController;
