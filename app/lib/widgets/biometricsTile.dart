import 'dart:async';
import 'package:flutter/material.dart';

import 'package:app/style.dart';
import 'package:app/api/http_api.dart';
import 'package:app/api/local_auth_api.dart';
import 'package:app/models/userdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';


class BiometricsTileWidget extends StatefulWidget 
{
	final UserDetails userDetails;
	final void Function(UserDetails) deleteTile;

	const BiometricsTileWidget({ Key? key, required this.userDetails, required this.deleteTile }) : super(key: key);

	@override
	_BiometricsTileState createState() => _BiometricsTileState();
}

class _BiometricsTileState extends State<BiometricsTileWidget> 
{
	@override
	Widget build(BuildContext context) 
	{
		return ListTile(
			key      : widget.key,
			title    : Text(widget.userDetails.email, style: Theme.of(context).textTheme.headline3), 
			tileColor: appBgColor,
			trailing: Wrap(
				children: <Widget>[
					IconButton(
						icon     : const Icon(Icons.fingerprint, color: appColor),
						color    : buttonColor,
						onPressed: () => _authenticate()
					),
					IconButton(
						icon     : const Icon(Icons.delete_outline, color: appColor),
						color    : buttonColor,
						onPressed: () => _delete(context)
					),
				],
			),
		);
	}

	void _delete(BuildContext context) 
	{
		showDialog(
			context: context,
			builder: (BuildContext ctx) 
			{
				return AlertDialog(
					key    : widget.key,
					title  : const Text('Please Confirm', style: TextStyle(color: textColor)),
					content: const Text('Are you sure you want to remove this account?', style: TextStyle(color: textColor)),
					backgroundColor: buttonColor,
					actions: <Widget>[
						TextButton( // "Yes" button
							child    : const Text('Yes', style: TextStyle(color: textColor)),
							onPressed: ()
							{
								Navigator.of(context).pop(); // Close the dialog
								Fluttertoast.showToast(msg: 'Account removed.', backgroundColor: buttonColor);
								widget.deleteTile(widget.userDetails);
							},
						),
						TextButton( // "No" button
							child    : const Text('No', style: TextStyle(color: appColor)),
							onPressed: () => Navigator.of(context).pop(), // Close the dialog
						),
					],
				);
			}
		);
	}

	Future<void> _authenticate() async
	{
		{
			final isAuthenticated = await LocalAuthApi.authenticate();
			if (isAuthenticated)
			{
				// TODO: create a dialog that says "Authenticated"
				await HttpApi.sendVerification(widget.userDetails.email, widget.userDetails.secretKey);
				Fluttertoast.showToast(msg: 'Authentication sent.', backgroundColor: buttonColor);
			}
		}
	}
}