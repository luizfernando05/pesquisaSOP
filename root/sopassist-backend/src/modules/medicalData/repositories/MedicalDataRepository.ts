import { Repository } from 'typeorm';
import { IMedicalDataRepository } from '../interfaces/IMedicalDataRepository';
import MedicalData from '../../../domain/entities/MedicalData';
import { AppDataSource } from '../../../config/data-source';

export class MedicalDataRepository implements IMedicalDataRepository {
  private ormRepository: Repository<MedicalData>;

  constructor() {
    this.ormRepository = AppDataSource.getRepository(MedicalData);
  }

  async create(medicalData: MedicalData): Promise<MedicalData> {
    return await this.ormRepository.save(medicalData);
  }

  async findById(id: string): Promise<MedicalData | null> {
    return this.ormRepository.findOne({ where: { id } });
  }

  async findByPatientId(patientId: string): Promise<MedicalData | null> {
    return this.ormRepository.findOne({
      where: {
        patientId: { id: patientId },
      },
      relations: ['patientId'],
    });
  }
}
