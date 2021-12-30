import { Express, Request, Response } from 'express'

import { validateRequest } from './middleware'
import { createUserSchema } from './schema/user.schema'
import { createUserHandler } from './controller/user.controller'


const routes = (app: Express) =>
{
	app.get('/healthcheck', (req: Request, res: Response) => res.sendStatus(200));

	// register user // create user
	app.post('/api/users', validateRequest(createUserSchema), createUserHandler);
}

export default routes;