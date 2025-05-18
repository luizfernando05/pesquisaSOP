import { Router } from 'express';
import CreateUserController from '../controllers/CreateUserController';

const userRoutes = Router();
const createUserController = new CreateUserController();

userRoutes.post('/', (req, res, next) => {
  createUserController.handle(req, res, next);
});

export { userRoutes };
