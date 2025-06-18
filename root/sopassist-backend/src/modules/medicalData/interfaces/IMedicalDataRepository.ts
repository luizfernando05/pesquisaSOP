import MedicalData from '../../../domain/entities/MedicalData';

export interface IMedicalDataRepository {
  create(medicalData: MedicalData): Promise<MedicalData>;
  findById(id: string): Promise<MedicalData | null>;
  findByPatientId(patientId: string): Promise<MedicalData | null>;
}
