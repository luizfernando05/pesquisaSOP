import { Router } from 'express';
import { userRoutes } from '../../../modules/users/routes/user.routes';
import { medicalDataRoutes } from '../../../modules/medicalData/routes/medicalData.routes';
import { predictionRoutes } from '../../../modules/prediction/routes/prediction.route';

const routes = Router();

routes.use('/user', userRoutes);
routes.use('/medical', medicalDataRoutes);
routes.use('/prediction', predictionRoutes);

export { routes };
