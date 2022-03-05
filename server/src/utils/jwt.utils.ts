import jwt from 'jsonwebtoken'
import config from 'config'
import { get } from 'lodash'
import logger from '../logger';

const PRIVATE_KEY = config.get('privateKey') as string;

export const sign = (object: Object, options?: jwt.SignOptions | undefined) => 
{
	return jwt.sign(object, PRIVATE_KEY, options);
}

export const decode = (token: string) => 
{
	try
	{
		const decoded = jwt.verify(token, PRIVATE_KEY);
		return { valid: true, expired: false, decoded: decoded };
	}
	catch (error: any)
	{
		return { valid: false, expired: error.message === 'jwt expired', decoded: null };
	}
}

export const decodeFingerprintSession = (token: string, secretKey: string) =>
{
	try 
	{
		logger.info(token);
		const payload = jwt.verify(token, secretKey);
		logger.info(payload);
		return payload;
	}
	catch (error: any)
	{
		logger.error(error);
		return false;
	}
}