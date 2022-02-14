import { AnySchema } from 'yup' // schema builder
import { Request, Response, NextFunction } from 'express'
import logger from '../logger'


// currying function
const validateRequest = (schema: AnySchema) => async (req: Request, res: Response, next: NextFunction) =>
{
	try
	{
		await schema.validate({
			body: req.body,
			query: req.query,
			params: req.params
		});

		return next();
	}
	catch (err: any)
	{
		logger.error(err);
		return res.status(400).send(err.errors); 
	}
}

export default validateRequest;