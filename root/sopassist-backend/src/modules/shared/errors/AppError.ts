export class AppError extends Error {
  public readonly statusCode: number;
  public readonly errors?: { [key: string]: string };

  constructor(
    message: string,
    statusCode = 400,
    errors?: { [key: string]: string }
  ) {
    super(message);
    this.statusCode = statusCode;
    this.errors = errors;

    Object.setPrototypeOf(this, AppError.prototype);
  }
}
