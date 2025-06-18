import Prediction from '../../../domain/entities/Prediction';

export interface IPredictionRepository {
  create(prediction: Prediction): Promise<Prediction>;
  findLatestByPatientId(patient: string): Promise<Prediction | null>;
}
