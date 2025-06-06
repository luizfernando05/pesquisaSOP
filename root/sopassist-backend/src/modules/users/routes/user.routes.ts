import { Router } from 'express';
import CreateUserController from '../controllers/CreateUserController';
import LoginUserController from '../controllers/LoginUserController';

const userRoutes = Router();
const createUserController = new CreateUserController();
const loginUserController = new LoginUserController();

userRoutes.post('/', (req, res, next) => {
  createUserController.handle(req, res, next);
});

userRoutes.post('/login', (req, res, next) => {
  loginUserController.handle(req, res, next);
});

export { userRoutes };
