import { Request, Response } from 'express'
import { get } from 'lodash'
import config from 'config'

import { 
	qrcodeHtml,
	profileHtml,
	errorHtml
} from '../html'


const publicPath = config.get('publicPath');

export const profilePageHandler = async (req: Request, res: Response) =>
{
	const user = get(req, 'user');
	if (!user)
		return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden
	
	res.send(profileHtml(user.username, user.email));
}

export const register2faHandler = async (req: Request, res: Response) =>
{
	const qrData = get(req, 'cookies.qrData');
	if (!qrData)
		return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden
		
	res.send(qrcodeHtml(qrData));
}

export const register3faHandler = async (req: Request, res: Response) =>
{
	//const userID = get(req, 'cookies.userID');
	//if (!userID)
	//	return res.redirect('/error?msg=Unauthorized+access&status=403'); // forbidden
		
	res.sendFile(publicPath + '/fingerprint.html');
}

export const errorPageHandler = async (req: Request, res: Response) =>
{
	if (!get(req, 'query.msg') || !get(req, 'query.status'))
		return res.send(errorHtml('NO error specified'));

	const status  = parseInt(req.query.status as string, 10);
	const message = decodeURIComponent(req.query.msg as string);
	return res.status(status).send(errorHtml(message));
}