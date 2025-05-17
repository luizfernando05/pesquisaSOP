import { NextFunction } from 'express';
import { ValidationError } from 'yup';
import { AppError } from './AppError';

export function handleValidationError(
  err: unknown,
  next: NextFunction
): boolean {
  if (err instanceof ValidationError) {
    const errors: Record<string, string> = {};

    err.inner.forEach((error) => {
      if (error.path && !errors[error.path]) {
        errors[error.path] = error.message;
      }
    });

    next(new AppError('Erro de validação', 400, errors));
    return true;
  }

  return false;
}
