import { get } from 'lodash'
import { Request, Response, NextFunction } from 'express'
import path from 'path'

const publicPath = path.resolve(__dirname, '../public/');
const requiresUser = async (req: Request, res: Response, next: NextFunction) =>
{
	const user = get(req, 'user');
	if (!user)
		return res.sendFile(publicPath + '/authRequired.html'); // access to the requested resource is forbidden
	
	return next();
}

export default requiresUser;