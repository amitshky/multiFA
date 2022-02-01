import { FilterQuery, LeanDocument, UpdateQuery } from 'mongoose'
import config from 'config'
import { get } from 'lodash'

import Session from "../model/session.model"
import { UserDocument } from '../model/user.model'
import { SessionDocument } from '../model/session.model'
import { sign, decode } from '../utils/jwt.utils'
import { findUser } from '../service/user.service'


export const createSession = async (userID: string, userAgent: string) =>
{
	const session = await Session.create({ user: userID, userAgent });
	return session.toJSON();
}

export const createAccessToken = ({
	user,
	session
}: {
	user: Omit<UserDocument, 'password'> | LeanDocument<Omit<UserDocument, 'password'>>;
	session: Omit<SessionDocument, 'password'> | LeanDocument<Omit<SessionDocument, 'password'>>;
}): string =>
{
	// build and return the new access token
	const accessToken = sign(
		{ ...user, session: session._id },
		{ expiresIn: config.get('accessTokenTTL')} // 15 minutes
	);

	return accessToken;
}

export const reIssueAccessToken = async ({ refreshToken }: { refreshToken: string }): Promise<false | string> =>
{
	const { decoded } = decode(refreshToken);
	if (!decoded || !get(decoded, '_id')) // or decoded?._id
		return false;
	
	// get the session
	const session = await Session.findById(get(decoded, '_id'));
	// check if session is still valid
	if (!session || !session?.valid)
		return false;

	const user = await findUser({ _id: session.user });
	if (!user)
		return false;

	const accessToken = createAccessToken({ user, session });
	return accessToken;
}

export const updateSession = async (
	query: FilterQuery<SessionDocument>,
	update: UpdateQuery<SessionDocument>
) => Session.updateOne(query, update);

export const findSessions = async (query: FilterQuery<SessionDocument>) => Session.find(query).lean();