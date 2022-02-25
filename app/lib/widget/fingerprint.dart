import 'package:flutter/material.dart';

import 'package:app/api/local_auth_api.dart';
import 'package:app/style.dart';


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
				}
			},
		);
	}

	// TODO: this is just for reference, remove it later
	//Widget buildText(String text, bool checked)
	//{
	//	return Container(
	//		margin: const EdgeInsets.symmetric(vertical: 8),
	//		child: Row(
	//			children: [
	//				checked
	//						? const Icon(Icons.check, color: Colors.green, size: 24)
	//						: const Icon(Icons.close, color: Colors.red, size: 24),
	//				const SizedBox(width: 12),
	//				Text(text, style: const TextStyle(fontSize: 24)),
	//			],
	//		),
	//	);
	//}
}