import { NextFunction, Request, Response } from 'express';
import { handleValidationError } from '../../shared/errors/handleValidationError';
import { CreateUserValidator } from '../validations/CreateUserValidator';
import { UserRepository } from '../repositories/UserRepository';
import CreateUserUseCase from '../useCases/CreateUserUseCase';

export class CreateUserController {
  async handle(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<Response | void> {
    try {
      await CreateUserValidator.validate(req.body, { abortEarly: false });

      const { name, email, state, password } = req.body;

      const userRepository = new UserRepository();
      const createUserUseCase = new CreateUserUseCase(userRepository);

      const user = await createUserUseCase.execute({
        name,
        email,
        state,
        password,
      });

      return res.status(200).json(user);
    } catch (err) {
      if (handleValidationError(err, next)) return;
      next(err);
    }
  }
}

export default CreateUserController;
