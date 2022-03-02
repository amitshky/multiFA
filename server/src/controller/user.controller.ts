import { Request, Response } from 'express'
import config from 'config'
import qrcode from 'qrcode'
import { get } from 'lodash'

import logger from '../logger'
import { createUser } from '../service/user.service'
import { errorHtml } from '../html'


export const createUserHandler = async (req: Request, res: Response) =>
{
	try
	{
		const user   = await createUser(req.body);
		const qrData = await user.generateSSKey();
		user.save();

		if (get(req, 'body.multiFactorOptions') === 'totp')
		{
			qrcode.toDataURL(decodeURIComponent(qrData), (err, data: string) =>
			{
				if (err)
				{
					logger.error(err);
					return res.redirect('/error?msg=Unable+to+generate+QR+code&status=500'); // unexpected condition
				}
				else
				{
					// WARNINIG: this is stupid
					// TODO: change it to something more secure
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
					//return res.json(omit(user.toJSON(), 'password', '__v')); // omit becuz deleting mutates the object 
				}
			});
		}
		else if (get(req, 'body.multiFactorOptions') === 'fingerprint')
		{
			return res.redirect('/reg-3fa');
		}
		else if (get(req, 'body.multiFactorOptions') === 'both')
		{
			// TODO: handle this case differently
			qrcode.toDataURL(decodeURIComponent(qrData), (err, data: string) =>
			{
				if (err)
				{
					logger.error(err);
					return res.redirect('/error?msg=Unable+to+generate+QR+code&status=500'); // unexpected condition
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
					//return res.json(omit(user.toJSON(), 'password', '__v')); // omit becuz deleting mutates the object 
				}
			});
		}
		
	}
	catch (err: any)
	{
		logger.error(err);
		return res.redirect(`/error?msg=${encodeURIComponent(err.message)}&status=409`);
	}
}
