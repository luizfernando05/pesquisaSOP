import { Router } from 'express';
import { userRoutes } from '../../../modules/users/routes/user.routes';
import { medicalDataRoutes } from '../../../modules/medicalData/routes/medicalData.routes';

const routes = Router();

routes.use('/user', userRoutes);
routes.use('/medical', medicalDataRoutes);

export { routes };
