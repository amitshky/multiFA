import { Request, Response } from 'express'
import { omit } from 'lodash'

import logger from '../../common/logger'
import { createUser } from '../service/user.service'


export const createUserHandler = async (req: Request, res: Response) =>
{
	try
	{
		const user = await createUser(req.body);
		return res.json(omit(user.toJSON(), 'password')); // omit becuz deleting mutates the object 
	}
	catch (err: any)
	{
		logger.error(err);
		return res.status(409).send(err.message);
	}
}
