import { get } from 'lodash'
import { Request, Response, NextFunction } from 'express'
import config from 'config'


const publicPath = config.get('publicPath');
const requiresUser = async (req: Request, res: Response, next: NextFunction) =>
{
	const user = get(req, 'user');
	if (!user)
		return res.status(403).sendFile(publicPath + '/authRequired.html'); // access to the requested resource is forbidden
	
	return next();
}

export default requiresUser;