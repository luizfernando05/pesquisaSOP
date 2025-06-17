import { NextFunction, Request, Response } from 'express';
import { AppError } from '../../errors/AppError';
import { verify } from 'jsonwebtoken';
import { ITokenPayload } from '../../interfaces/ITokenPayload';
import { UserRepository } from '../../../users/repositories/UserRepository';

export const ensureUserAuthenticade = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return next(new AppError('JWT token is missing', 401));
  }

  const [, token] = authHeader.split(' ');

  try {
    const jwtSecret = process.env.JWT_SECRET;

    if (!jwtSecret) {
      return next(new AppError('Erro interno do servidor', 500));
    }

    const decoded = verify(token, jwtSecret) as unknown as ITokenPayload;

    const userRepository = new UserRepository();
    const user = await userRepository.findById(decoded.id);

    if (!user) {
      return next(new AppError('User does not have user privilages.', 403));
    }

    req.user = {
      id: decoded.id,
      role: 'user',
    };

    return next();
  } catch {
    return next(new AppError('Invalid JWT token', 401));
  }
};
