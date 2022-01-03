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
import { sign } from '../utils/jwt.utils'


export const createUserSessionHandler = async (req: Request, res: Response) =>
{
	// validate email and password
	let user = await validatePassword(req.body) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;

	if (!user)
		return res.status(401).send('Invalid email or password');
		
	user = await validateTOTP(req.body) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
	if (!user)
		return res.status(401).send('Invalid code');

	// create a session
	const session = await createSession(user._id, req.get('user-agent') || '') as Omit<SessionDocument, 'password'> | LeanDocument<Omit<SessionDocument, 'password'>>;

	// create access token and refresh token
	const accessToken = createAccessToken({ user, session });
	const refreshToken = sign(session, { expiresIn: config.get('refreshTokenTTL') }); // 1 year

	return res.send({ accessToken, refreshToken });
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