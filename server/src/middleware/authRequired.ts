import {Request,Response, NextFunction} from 'express';
import {get} from 'lodash';
import config from 'config'


const publicPath = config.get('publicPath');
const authRequired = async (req: Request, res: Response, next: NextFunction) =>
{
	const user = get(req, 'user');
	if(!user)
		return res.sendStatus(403).sendFile(publicPath + '/authRequired.html');
	
	return next();
}

export default authRequired;