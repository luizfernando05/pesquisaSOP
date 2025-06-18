import { Repository } from 'typeorm';
import { IPredictionRepository } from '../interfaces/IPredictionRepository';
import Prediction from '../../../domain/entities/Prediction';
import { AppDataSource } from '../../../config/data-source';

export class PredictionRepository implements IPredictionRepository {
  private ormRepository: Repository<Prediction>;

  constructor() {
    this.ormRepository = AppDataSource.getRepository(Prediction);
  }

  async create(prediction: Prediction): Promise<Prediction> {
    const newPrediction = this.ormRepository.create(prediction);
    return this.ormRepository.save(newPrediction);
  }

  async findLatestByPatientId(patientId: string): Promise<Prediction | null> {
    const prediction = await this.ormRepository.findOne({
      where: { patient: { id: patientId } },
      order: { createdAt: 'DESC' },
      relations: ['patient'],
    });

    return prediction || null;
  }
}
