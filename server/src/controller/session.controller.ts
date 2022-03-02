import config from 'config'
import { get } from 'lodash'
import { Request, Response } from 'express'
import { LeanDocument } from 'mongoose'

import { UserDocument } from '../model/user.model'
import { SessionDocument } from '../model/session.model'
import { findUser, validatePassword, validateTOTP } from '../service/user.service'
import { 
	createSession, 
	createAccessToken, 
	updateSession, 
	findSessions 
} from '../service/session.service'
import { sign, decode } from '../utils/jwt.utils'


export const createUserSessionHandler = async (req: Request, res: Response) =>
{
	// validate email and password
	const user = await validatePassword(req.body) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
	if (!user)
		return res.redirect('/error?msg=Invalid+username+or+password&status=400');

	if ((user.multiFactorOptions === 'totp') || (user.multiFactorOptions === 'both'))
	{
		// WARNINIG: this is stupid
		// TODO: change it to something more secure
		const nextRoute = '/check-2fa';
		res.cookie('userID', user._id, {
			maxAge  : config.get('verificationCookiesTTL'), // 5 min
			httpOnly: true,
			domain  : config.get('host'),
			path    : `/api/sessions${nextRoute}`,
			sameSite: 'strict',
			secure  : false,
		});
		return res.redirect(nextRoute);
	}
	else if (user.multiFactorOptions === 'fingerprint')
	{
		// WARNINIG: this is stupid
		// TODO: change it to something more secure
		const nextRoute = '/check-3fa';
		res.cookie('userID', user._id, {
			maxAge  : config.get('verificationCookiesTTL'), // 5 min
			httpOnly: true,
			domain  : config.get('host'),
			path    : `/api/sessions${nextRoute}`,
			sameSite: 'strict',
			secure  : false,
		});
		return res.redirect(nextRoute);
	}
	else
	{
		return res.redirect('/error?msg=Invalid+multifactor+options&status=400');
	}
}

export const invalidateUserSessionHandler = async (req: Request, res: Response) =>
{
	const sessionID = get(req, 'user.session');
	await updateSession({ _id: sessionID }, { valid: false });
	return res.redirect('/');
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
		return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden
	
	const user = await findUser({ _id: userID }) as LeanDocument<Omit<UserDocument, 'password'>>;

	// TODO: check multiFactorOptions property of the user (from db) before generating access tokens and stuff
	if (user.multiFactorOptions === 'totp')
	{
		const userTotp = await validateTOTP({ userID: userID, token: req.body.token }) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
		if (!userTotp)
			return res.redirect('/error?msg=Invalid+token&status=400');
		// create a session
		const session = await createSession(userTotp._id, req.get('user-agent') || '') as Omit<SessionDocument, 'password'> | LeanDocument<Omit<SessionDocument, 'password'>>;
		// create access token and refresh token
		const accessToken  = createAccessToken({ user: userTotp, session });
		const refreshToken = sign(session, { expiresIn: config.get('refreshTokenTTL') }); // 1 year

		res.cookie('accessToken', accessToken, {
			maxAge  : 900000, // 15 mins
			httpOnly: true,
			domain  : config.get('host'),
			path    : '/',
			sameSite: 'strict',
			secure  : false,
		});
		res.cookie('refreshToken', refreshToken, {
			maxAge  : 3.154e10, // 1 year
			httpOnly: true,
			domain  : config.get('host'),
			path    : '/',
			sameSite: 'strict',
			secure  : false,
		});
		return res.redirect('/profile');
	}
	else if (user.multiFactorOptions === 'both')
	{
		const userTotp = await validateTOTP({ userID: userID, token: req.body.token }) as Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
		if (!userTotp)
			return res.redirect('/error?msg=Invalid+token&status=400');
		
		res.cookie('userID', user._id, {
			maxAge  : config.get('verificationCookiesTTL'), // 5 min
			httpOnly: true,
			domain  : config.get('host'),
			path    : `/api/sessions/check-3fa`,
			sameSite: 'strict',
			secure  : false,
		});
		return res.redirect('/check-3fa')
	}
	else
	{
		return res.redirect('/error?msg=Invalid+multifactor+options&status=400');
	}
}

export const threeFASessionHandler = async (req: Request, res: Response) =>
{
	const userID = get(req, 'cookies.userID');
	if (!userID)
		return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden

	// TODO: implement threeFASessionHandler
	return res.redirect('/error?msg=Fingerprint+verification+not+implemented+yet&status=200');
}