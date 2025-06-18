import { Router } from 'express';
import CreateMedicalDataController from '../controllers/CreateMedicalDataController';
import { ensureUserAuthenticade } from '../../shared/middlewares/auth/ensureUserAuthenticade';

const medicalDataRoutes = Router();
const createMedicalDataController = new CreateMedicalDataController();

medicalDataRoutes.post('/', ensureUserAuthenticade, (req, res, next) => {
  createMedicalDataController.handle(req, res, next);
});

export { medicalDataRoutes };
