import { Router } from 'express';
import GenerateAdviceController from '../controllers/GenerateAdviceController';

const adviceRoutes = Router();
const generateAdviceController = new GenerateAdviceController();

adviceRoutes.get('/get', (req, res, next) => {
  generateAdviceController.handle(req, res, next);
});

export { adviceRoutes };
