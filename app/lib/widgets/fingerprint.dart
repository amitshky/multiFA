import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/style.dart';
import 'package:app/api/http_api.dart';
import 'package:app/api/local_auth_api.dart';


class FingerprintWidget extends StatelessWidget
{
	const FingerprintWidget({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context)
	{
		return ElevatedButton.icon(
			icon : const Icon(Icons.fingerprint, size: 26, color: appColor),
			label: Text('Authenticate', style: Theme.of(context).textTheme.bodyText1),
			style: ElevatedButton.styleFrom(
				primary  : appBgColor,
				elevation: 0,
			),
			onPressed: () async
			{
				final isAuthenticated = await LocalAuthApi.authenticate();
				if (isAuthenticated)
				{
					// TODO: create a dialog that says "Authenticated"
					await HttpApi.sendVerification('test@test.com', 'HQ2FKJRXMFWUQZDFPJRCKNZEKQ7HWNCFMMWDCL2DORKEKRRMLN4Q');
					Fluttertoast.showToast(msg: 'Authentication sent.', backgroundColor: buttonColor);
				}
			},
		);
	}
}