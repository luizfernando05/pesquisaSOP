import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import User from './User';

@Entity('prediction')
export class Prediction {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'patient_id' })
  patient: User;

  @Column({ name: 'prediction_result', type: 'varchar', nullable: false })
  predictionResult: string;

  @Column({ name: 'confidence_score', type: 'varchar', nullable: false })
  confidenceScore: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}

export default Prediction;
