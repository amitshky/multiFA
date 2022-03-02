import { Request, Response } from 'express'
import config from 'config'
import qrcode from 'qrcode'
import { get } from 'lodash'

import logger from '../logger'
import { createUser } from '../service/user.service'


export const createUserHandler = async (req: Request, res: Response) =>
{
	try
	{
		const user   = await createUser(req.body);
		const qrData = await user.generateSSKey();
		user.save();

		let nextPath : string | undefined       = undefined;
		let nextUserIDPath : string | undefined = undefined;

		switch (get(req, 'body.multiFactorOptions'))
		{
			case 'totp':
				nextPath       = '/reg-2fa';
				nextUserIDPath = '/api/users/reg-2fa';
				break;
			
			case 'fingerprint':
				nextPath       = '/reg-3fa';
				nextUserIDPath = '/api/users/reg-3fa';
				break;

			case 'both':
				nextPath       = '/reg-2fa';
				nextUserIDPath = '/api/users/reg-2fa';
				break;
		}

		if (!nextPath || !nextUserIDPath)
			return res.redirect('/error?msg=Error+in+selecting+authentication+type&status=400');

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
					maxAge  : config.get('verificationCookiesTTL'), // 5 min
					httpOnly: true,
					domain  : config.get('host'),
					path    : nextPath,
					sameSite: 'strict',
					secure  : false,
				});
				res.cookie('userID', user._id, {
					maxAge  : config.get('verificationCookiesTTL'), // 5 min
					httpOnly: true,
					domain  : config.get('host'),
					path    : nextUserIDPath,
					sameSite: 'strict',
					secure  : false,
				});
		
				return res.redirect(nextPath!);
				//return res.json(omit(user.toJSON(), 'password', '__v')); // omit becuz deleting mutates the object 
			}
		});
	}
	catch (err: any)
	{
		logger.error(err);
		return res.redirect(`/error?msg=${encodeURIComponent(err.message)}&status=409`);
	}
}
