import { hash } from 'bcryptjs';
import User from '../../../domain/entities/User';
import { AppError } from '../../shared/errors/AppError';
import { CreateUserDTO } from '../dtos/CreateUserDTO';
import { IUserRepository } from '../interfaces/IUserRepository';

export class CreateUserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(data: CreateUserDTO): Promise<User> {
    const existingUser = await this.userRepository.findByEmail(data.email);

    if (existingUser) {
      throw new AppError('Erro de validação', 409, {
        email: 'Email já está em uso',
      });
    }

    const hashedPassword = await hash(data.password, 10);

    const user = new User();
    user.name = data.name;
    user.email = data.email;
    user.state = data.state;
    user.password = hashedPassword;

    return this.userRepository.create(user);
  }
}

export default CreateUserUseCase;
