import { Router } from 'express';
import PredictionController from '../controllers/PredictionController';
import { ensureUserAuthenticade } from '../../shared/middlewares/auth/ensureUserAuthenticade';

const predictionRoutes = Router();
const predictionController = new PredictionController();

predictionRoutes.post('/', ensureUserAuthenticade, (req, res, next) => {
  predictionController.handle(req, res, next);
});

export { predictionRoutes };
