import { NextFunction, Request, Response } from 'express';
import { MedicalDataRepository } from '../repositories/MedicalDataRepository';
import { UserRepository } from '../../users/repositories/UserRepository';
import CreateMedicalDataUseCase from '../useCases/CreateMedicalDataUseCase';

export class CreateMedicalDataController {
  async handle(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<Response | void> {
    try {
      const patientId = req.user?.id;

      const {
        weight,
        cycle,
        amg,
        weightGain,
        hairLoss,
        darkeningSkin,
        pimple,
        fastFood,
        leftFollicles,
        rightFollicles,
      } = req.body;

      const medicalDataRepository = new MedicalDataRepository();
      const userRepository = new UserRepository();
      const createMedicalDataUseCase = new CreateMedicalDataUseCase(
        medicalDataRepository,
        userRepository
      );

      const medicalData = await createMedicalDataUseCase.execute({
        patientId,
        weight,
        cycle,
        amg,
        weightGain,
        hairLoss,
        darkeningSkin,
        pimple,
        fastFood,
        leftFollicles,
        rightFollicles,
      });

      return res.status(201).json(medicalData);
    } catch (err) {
      next(err);
    }
  }
}

export default CreateMedicalDataController;
