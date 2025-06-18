import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import MedicalData from './MedicalData';
import Prediction from './Prediction';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', nullable: false })
  name: string;

  @Column({ type: 'varchar', nullable: false, unique: true })
  email: string;

  @Column({ type: 'varchar', nullable: false })
  state: string;

  @Column({ type: 'varchar', nullable: false })
  password: string;

  @OneToMany(() => MedicalData, (medicalData) => medicalData.patientId)
  medicalData: MedicalData[];

  @OneToMany(() => Prediction, (prediction) => prediction.patient)
  prediction: Prediction[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}

export default User;
