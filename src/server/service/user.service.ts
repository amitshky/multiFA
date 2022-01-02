import { omit } from 'lodash'
import { DocumentDefinition, FilterQuery } from 'mongoose'

import logger from '../../common/logger'
import User, { UserDocument } from '../model/user.model'

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
	
	return omit(user.toJSON(), 'password', 'sskey'); 
}

export const validateTOTP = async ({ email, token }: { email: UserDocument['email'], token: string }) =>
{
	const user = await User.findOne({ email: email });
	if (!user)
		return false;
	
	const isValid = await user.compareToken(token);
	if (!isValid)
		return false;
	
	return omit(user.toJSON(), 'password', 'sskey');
}

export const findUser = async (query: FilterQuery<UserDocument>) => User.findOne(query).lean(); // lean returns plain old js objects (POJOs) instead of mongoose document // faster queries