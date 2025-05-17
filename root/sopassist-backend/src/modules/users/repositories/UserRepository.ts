import { Repository } from 'typeorm';
import { IUserRepository } from '../interfaces/IUserRepository';
import User from '../../../domain/entities/User';
import { AppDataSource } from '../../../config/data-source';

export class UserRepository implements IUserRepository {
  private ormRepository: Repository<User>;

  constructor() {
    this.ormRepository = AppDataSource.getRepository(User);
  }

  create(user: User): Promise<User> {
    const createUser = this.ormRepository.create(user);
    return this.ormRepository.save(createUser);
  }

  findByEmail(email: string): Promise<User | null> {
    return this.ormRepository.findOne({ where: { email } });
  }
}
