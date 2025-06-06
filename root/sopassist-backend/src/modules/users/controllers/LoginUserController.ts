import { NextFunction, Request, Response } from 'express';
import { handleValidationError } from '../../shared/errors/handleValidationError';
import { LoginDoctorValidator } from '../validations/LoginUserValidator';
import { UserRepository } from '../repositories/UserRepository';
import LoginUserUseCase from '../useCases/LoginUserUseCase';

export class LoginUserController {
  async handle(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<Response | void> {
    try {
      await LoginDoctorValidator.validate(req.body, { abortEarly: false });

      const { email, password } = req.body;

      const userRepository = new UserRepository();
      const loginUserUseCase = new LoginUserUseCase(userRepository);

      const token = await loginUserUseCase.execute({ email, password });

      return res.status(200).json(token);
    } catch (err) {
      if (handleValidationError(err, next)) return;
      next(err);
    }
  }
}

export default LoginUserController;
