import { compare } from 'bcryptjs';
import { AppError } from '../../shared/errors/AppError';
import { LoginUserDTO } from '../dtos/LoginUserDTO';
import { IUserRepository } from '../interfaces/IUserRepository';
import { sign } from 'jsonwebtoken';

export class LoginUserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute({ email, password }: LoginUserDTO): Promise<string> {
    const user = await this.userRepository.findByEmail(email);

    if (!user) {
      throw new AppError('Erro de autenticação', 401, {
        email: 'Email não encontrado',
      });
    }

    const passwordCheck = await compare(password, user.password);

    if (!passwordCheck) {
      throw new AppError('Erro de autenticação', 401, {
        password: 'Senha incorreta',
      });
    }

    if (!process.env.JWT_SECRET) {
      throw new AppError('JWT secret is missing', 500);
    }

    const token = sign({ id: user.id }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    return token;
  }
}

export default LoginUserUseCase;
