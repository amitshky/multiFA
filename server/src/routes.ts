import { Express, Request, Response } from 'express'
import path from 'path'

import { validateRequest, requiresUser } from './middleware'
import { createUserSchema, createUserSessionSchema } from './schema/user.schema'
import { createUserHandler } from './controller/user.controller'
import { 
	createUserSessionHandler, 
	getUserSessionsHandler, 
	invalidateUserSessionHandler,
	twoFASessionHandler
} from './controller/session.controller'


const publicPath = path.resolve(__dirname, '../public/');

const routes = (app: Express): void =>
{
	app.get('/', (req: Request, res: Response) => res.redirect('/login'));
	app.get('/healthcheck', (req: Request, res: Response) => res.sendStatus(200));

	// login page
	app.get('/login',     (req: Request, res: Response) => res.sendFile(publicPath + '/login.html'));
	// 2fa page
	app.get('/check-2fa', (req: Request, res: Response) => res.sendFile(publicPath + '/totp.html'));
	
	// register page
	app.get('/register',  (req: Request, res: Response) => res.sendFile(publicPath + '/register.html'));

	// register user // create user
	app.post('/api/users', validateRequest(createUserSchema), createUserHandler);

	// login // create session
	app.post('/api/sessions', validateRequest(createUserSessionSchema), createUserSessionHandler);
	// check totp
	app.post('/api/sessions/check-2fa', twoFASessionHandler); // TODO: modify requiresUser middleware and use it here

	// get the user's sessions
	app.get('/api/sessions', requiresUser, getUserSessionsHandler);

	// logout // delete session
	app.delete('/api/sessions', requiresUser, invalidateUserSessionHandler);

	// default error page
	app.get('*', (req: Request, res: Response) => res.status(404).sendFile(publicPath + '/error.html'));
}

export default routes;