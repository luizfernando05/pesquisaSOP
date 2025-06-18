import MedicalData from '../../../domain/entities/MedicalData';
import { AppError } from '../../shared/errors/AppError';
import { IUserRepository } from '../../users/interfaces/IUserRepository';
import { CreateMedicalDataDTO } from '../dtos/CreateMedicalDataDTO';
import { IMedicalDataRepository } from '../interfaces/IMedicalDataRepository';

export class CreateMedicalDataUseCase {
  constructor(
    private medicalDataRepository: IMedicalDataRepository,
    private userRepository: IUserRepository
  ) {}

  async execute(data: CreateMedicalDataDTO): Promise<MedicalData> {
    const { patientId } = data;

    const user = await this.userRepository.findById(patientId);

    if (!user) {
      throw new AppError('Usuário não encontardo', 400);
    }

    const existingData =
      await this.medicalDataRepository.findByPatientId(patientId);

    if (existingData) {
      throw new AppError('Dados médicos para este paciente já existem');
    }

    const medicalData = new MedicalData();
    Object.assign(medicalData, data);

    return this.medicalDataRepository.create(medicalData);
  }
}

export default CreateMedicalDataUseCase;
