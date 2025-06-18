import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import User from './User';

@Entity('medical_data')
export class MedicalData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'patient_id' })
  patientId: User;

  @Column({ type: 'float', nullable: false })
  weight: number;

  @Column({ type: 'integer', nullable: false })
  cycle: number;

  @Column({ type: 'float', nullable: false })
  amg: number;

  @Column({ name: 'weight_gain', type: 'boolean', nullable: false })
  weightGain: boolean;

  @Column({ name: 'hair_loss', type: 'boolean', nullable: false })
  hairLoss: boolean;

  @Column({ name: 'darkening_skin', type: 'boolean', nullable: false })
  darkeningSkin: boolean;

  @Column({ type: 'boolean', nullable: false })
  pimple: boolean;

  @Column({ name: 'fast_food', type: 'boolean', nullable: false })
  fastFood: boolean;

  @Column({ name: 'left_follicles', type: 'float', nullable: false })
  leftFollicles: number;

  @Column({ name: 'right_follicles', type: 'float', nullable: false })
  rightFollicles: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}

export default MedicalData;
