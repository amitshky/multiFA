import { Express, Request, Response } from 'express'

import { validateRequest, requiresUser } from './middleware'
import { createUserSchema, createUserSessionSchema } from './schema/user.schema'

import { createUserHandler } from './controller/user.controller'
import { 
	createUserSessionHandler, 
	getUserSessionsHandler, 
	invalidateUserSessionHandler 
} from './controller/session.controller'


const routes = (app: Express): void =>
{
	app.get('/healthcheck', (req: Request, res: Response) => res.sendStatus(200));

	// register user // create user
	app.post('/api/users', validateRequest(createUserSchema), createUserHandler);

	// login // create session
	app.post('/api/sessions', validateRequest(createUserSessionSchema), createUserSessionHandler)

	// get the user's sessions
	app.get('/api/sessions', requiresUser, getUserSessionsHandler);

	// logout // delete session
	app.delete('/api/sessions', requiresUser, invalidateUserSessionHandler);
}

export default routes;