import { NextFunction, Request, Response } from 'express';
import { AppError } from '../errors/AppError';

export const errorMiddleware = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
): Response => {
  if (err instanceof AppError) {
    const response: any = {
      status: 'error',
      messages: err.message,
    };

    if (err.errors) {
      response.errors = err.errors;
    }

    return res.status(err.statusCode).json(response);
  }

  console.log(err);

  return res.status(500).json({
    status: 'error',
    message: 'Erro interno do servidor',
  });
};
