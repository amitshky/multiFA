import { Request, Response } from 'express'
import { omit, get } from 'lodash'
import config from 'config'
import qrcode from 'qrcode'

import logger from '../logger'
import { createUser } from '../service/user.service'
import { qrcodeHtml } from '../html'


export const createUserHandler = async (req: Request, res: Response) =>
{
	try
	{
		// TODO: dont save the user here
		const user   = await createUser(req.body);
		const qrData = await user.generateSSKey();
		user.save();
		//return res.json(omit(user.toJSON(), 'password', '__v')); // omit becuz deleting mutates the object 
		qrcode.toDataURL(decodeURIComponent(qrData), (err, data: string) =>
		{
			if (err)
			{
				logger.error(err);
				return res.status(500).send('Unable to generate QR code!');
			}
			else
			{
				res.cookie('qrData', data, { // to display QR code in /reg-2fa
					maxAge: 300000, // 5 min
					httpOnly: true,
					domain: config.get('host'),
					path: '/reg-2fa',
					sameSite: 'strict',
					secure: false,
				});

				res.cookie('userID', user._id, {
					maxAge: 300000, // 5 min
					httpOnly: true,
					domain: config.get('host'),
					path: '/api/users/reg-2fa',
					sameSite: 'strict',
					secure: false,
				});
		
				return res.redirect('/reg-2fa');
			}
		});
	}
	catch (err: any)
	{
		logger.error(err);
		return res.status(409).send(err.message);
	}
}

export const register2faHandler = async (req: Request, res: Response) =>
{
	// TODO: save the user here
	const qrData = get(req, 'cookies.qrData');
	if (!qrData)
		return res.sendStatus(403); // forbidden
	res.send(qrcodeHtml(qrData));
}