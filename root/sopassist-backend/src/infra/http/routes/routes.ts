import { Router } from 'express';
import { userRoutes } from '../../../modules/users/routes/user.routes';

const routes = Router();

routes.use('/user', userRoutes);

export { routes };
