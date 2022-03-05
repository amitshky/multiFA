import 'dart:async';
import 'package:flutter/material.dart';

import 'package:app/style.dart';
import 'package:app/api/totp_api.dart';
import 'package:app/api/http_api.dart';
import 'package:app/api/local_auth_api.dart';
import 'package:app/models/userdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';


class TotpWidget extends StatefulWidget 
{
	final UserDetails userDetails;
	final void Function(UserDetails) deleteTile;
	final bool hasBiometric;

	const TotpWidget({ Key? key, required this.userDetails, required this.deleteTile, required this.hasBiometric }) : super(key: key);

	@override
	_TotpWidgetState createState() => _TotpWidgetState();
}

class _TotpWidgetState extends State<TotpWidget> 
{
	Timer? timer;
	late int unixTime;
	late String totp;
	late int timeRemaining;

	@override
	void initState()
	{
		super.initState();
		unixTime      = DateTime.now().millisecondsSinceEpoch ~/ 1000;
		totp          = TOTP.generateTOTP(widget.userDetails.secretKey, unixTime);
		timeRemaining = 30 - (unixTime % 30);

		timer = Timer.periodic(const Duration(seconds: 1), (_)
		{
			setState(()
			{
				unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

				if ((unixTime % 30) == 0) totp = TOTP.generateTOTP(widget.userDetails.secretKey, unixTime);

				timeRemaining = 30 - (unixTime % 30);
			});
		});
	}

	@override
	void dispose()
	{
		_stopTimer();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) 
	{
		return ListTile(
			key      : widget.key,
			title    : Text(totp.substring(0, 3) + ' ' + totp.substring(3), style: Theme.of(context).textTheme.headline2), 
			subtitle : Text(widget.userDetails.email, style: Theme.of(context).textTheme.bodyText1),
			tileColor: appBgColor,
			leading  : SizedBox(
				width : 32,
				height: 32,
				child : Stack(
					fit : StackFit.expand,
					children: <Widget>[
						Center(child: Text('$timeRemaining', style: Theme.of(context).textTheme.bodyText2)),
						CircularProgressIndicator(
							value          : 1 - (timeRemaining / 30),
							backgroundColor: circularProgIndBgColor,
							color          : appColor,
							strokeWidth    : 2,
						),
					],
				),
			),
			trailing: Wrap(
				children: <Widget>[
					if (widget.hasBiometric) IconButton(
						icon     : const Icon(Icons.fingerprint, color: appColor),
						onPressed: () => _authenticate()
					),
					IconButton(
						icon     : const Icon(Icons.delete_outline, color: appColor),
						onPressed: () => _delete(context)
					),
				],
			),
		);
	}
	
	void _stopTimer()
	{
		try
		{
			if (mounted) setState(() => timer?.cancel());
		}
		catch(_) 
		{
			// no proper response for this exception; seems to be only a debug thing
			return;
		}
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