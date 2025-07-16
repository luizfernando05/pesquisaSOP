import { NextFunction, Request, Response } from 'express';
import { MedicalDataRepository } from '../../medicalData/repositories/MedicalDataRepository';
import { PredictionRepository } from '../../prediction/repositories/PredictionRepository';
import AdviceService from '../services/AdiviceService';
import GenerateAdviceUseCase from '../useCases/GenerateAdviceUseCase';

export class GenerateAdviceController {
  async handle(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<Response | void> {
    try {
      const patientId = req.user?.id;

      const medicalDataRepository = new MedicalDataRepository();
      const predictionRepository = new PredictionRepository();
      const adviceService = new AdviceService();

      const generateAdviceUseCase = new GenerateAdviceUseCase(
        medicalDataRepository,
        predictionRepository,
        adviceService
      );

      const advice = await generateAdviceUseCase.execute(patientId);

      return res.status(200).json(advice);
    } catch (err) {
      next(err);
    }
  }
}

export default GenerateAdviceController;
