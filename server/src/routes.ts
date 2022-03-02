import { Express, Request, Response } from 'express'
import config from 'config'

import { validateRequest, requiresUser } from './middleware'
import { createUserSchema, createUserSessionSchema } from './schema/user.schema'
import { createUserHandler } from './controller/user.controller'
import { 
	register2faHandler,
	register3faHandler,
	profilePageHandler,
	errorPageHandler
} from './controller/routes.controller'
import { 
	createUserSessionHandler, 
	getUserSessionsHandler, 
	invalidateUserSessionHandler,
	twoFASessionHandler
} from './controller/session.controller'


const publicPath = config.get('publicPath');

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
	// 2fa registration
	app.get('/reg-2fa', register2faHandler); // TODO: maybe implement something like requiresUser middleware
	// 3fa registration
	app.get('/reg-3fa', register3faHandler); // TODO: maybe implement something like requiresUser middleware

	// profile page
	app.get('/profile', requiresUser, profilePageHandler);

	// register user // create user
	app.post('/api/users', validateRequest(createUserSchema), createUserHandler);
	// verify 2fa registration
	app.post('/api/users/reg-2fa', twoFASessionHandler);

	// login // create session
	app.post('/api/sessions', validateRequest(createUserSessionSchema), createUserSessionHandler);
	// check totp
	app.post('/api/sessions/check-2fa', twoFASessionHandler);

	// get the user's sessions
	app.get('/api/sessions', requiresUser, getUserSessionsHandler);
	// logout // delete session
	app.delete('/api/sessions/', requiresUser, invalidateUserSessionHandler);

	// error route
	app.get('/error', errorPageHandler)

	// default error page
	app.get('*', (req: Request, res: Response) => res.redirect('/error?msg=Resource+not+found&status=404'));
}

export default routes;