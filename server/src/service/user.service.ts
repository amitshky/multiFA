import { omit } from 'lodash'
import { DocumentDefinition, FilterQuery, UpdateQuery } from 'mongoose'

import logger from '../logger'
import User, { UserDocument, privateFields } from '../model/user.model'
import { decodeFingerprintSession } from '../utils/jwt.utils'

export const createUser = async (input: DocumentDefinition<UserDocument>) =>
{
	try
	{
		return await User.create(input);
	}
	catch (err: any)
	{
		logger.error(err);
		throw new Error(err);
	}
}

export const validatePassword = async ({ email, password }: { email: UserDocument['email'], password: string }) => 
{
	const user = await User.findOne({ email: email });
	if (!user)
		return false
	
	const isValid = await user.comparePassword(password);
	if (!isValid)
		return false;
	
	return omit(user.toJSON(), privateFields); 
}

export const validateTOTP = async ({ userID, token }: { userID: string, token: string }) =>
{
	const user = await User.findOne({ _id: userID });
	if (!user)
		return false;
	
	const isValid = await user.compareToken(token);
	if (!isValid)
		return false;
	
	return omit(user.toJSON(), privateFields);
}

export const validateFingerprintSessionStatus = async (userID: string) =>
{
	const user = await User.findOne({ _id: userID });
	if (!user)
		return false;
	
	const isValid = decodeFingerprintSession(user.sessionToken, user.sskey);
	if (!isValid)
		return false;

	await User.updateOne({ _id: user._id }, { sessionToken: 'N/A' }); // invalidate session token after success
	return omit(user.toJSON(), privateFields);
}

export const findUser = async (query: FilterQuery<UserDocument>) => User.findOne(query).lean(); // lean returns plain old js objects (POJOs) instead of mongoose document // faster queries

export const updateUser = async (
	query: FilterQuery<UserDocument>,
	update: UpdateQuery<UserDocument>
) => User.updateOne(query, update);