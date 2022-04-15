import { get } from 'lodash'
import { Request, Response, NextFunction } from 'express'


const requiresUser = async (req: Request, res: Response, next: NextFunction) =>
{
	const user = get(req, 'user');
	if (!user)
		return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden
	
	return next();
}

export default requiresUser;