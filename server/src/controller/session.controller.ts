import config from 'config'
import { get } from 'lodash'
import { Request, Response } from 'express'
import { LeanDocument } from 'mongoose'

import { UserDocument } from '../model/user.model'
import { SessionDocument } from '../model/session.model'
import { validatePassword, validateTOTP } from '../service/user.service'
import { 
	createSession, 
	createAccessToken, 
	updateSession, 
	findSessions 
} from '../service/session.service'
import { sign, decode } from '../utils/jwt.utils'
import logger from '../logger'
import path from 'path'

const publicPath = path.resolve(__dirname, '../../public/');

export const createUserSessionHandler = async (req: Request, res: Response) =>
{
	// validate email and password
	const user = await validatePassword(req.body) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
	if (!user)
		return res.sendFile(publicPath + '/invalid_password.html');

	// WARNINIG: this is stupid
	// TODO: change it to something more secure
	res.cookie('userID', user._id, {
		maxAge: 300000, // 5 min
		httpOnly: true,
		domain: config.get('host'),
		path: '/api/sessions/check-2fa',
		sameSite: 'strict',
		secure: false,
	});
	return res.redirect('/check-2fa');
}

export const invalidateUserSessionHandler = async (req: Request, res: Response) =>
{
	const sessionID = get(req, 'user.session');
	await updateSession({ _id: sessionID }, { valid: false });
	return res.sendStatus(200);
}

export const getUserSessionsHandler = async (req: Request, res: Response) => 
{
	const userID = get(req, 'user._id');
	const sessions = await findSessions({ user: userID, valid: true });
	return res.send(sessions);
}

export const twoFASessionHandler = async (req: Request, res: Response) =>
{
	const userID = get(req, 'cookies.userID');
	if (!userID)
		return res.sendStatus(403); // forbidden
	const user = await validateTOTP({ userID: userID, token: req.body.token }) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
	if (!user)
		return res.sendFile(publicPath + '/invalid_token.html');

	// create a session
	const session = await createSession(user._id, req.get('user-agent') || '') as Omit<SessionDocument, 'password'> | LeanDocument<Omit<SessionDocument, 'password'>>;

	// create access token and refresh token
	const accessToken = createAccessToken({ user, session });
	const refreshToken = sign(session, { expiresIn: config.get('refreshTokenTTL') }); // 1 year

	res.cookie('accessToken', accessToken, {
		maxAge: 900000, // 15 mins
		httpOnly: true,
		domain: config.get('host'),
		path: '/',
		sameSite: 'strict',
		secure: false,
	});
	res.cookie('refreshToken', refreshToken, {
		maxAge: 3.154e10, // 1 year
		httpOnly: true,
		domain: config.get('host'),
		path: '/',
		sameSite: 'strict',
		secure: false,
	});
	return res.sendFile(publicPath + '/placeholder.html');
}