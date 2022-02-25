import 'dart:async';
import 'package:flutter/material.dart';

import 'package:app/api/totp_api.dart';
import 'package:app/style.dart';
import 'package:app/data/userdetails.dart';

class TotpWidget extends StatefulWidget 
{
	final UserDetails userDetails;
	final void Function(int) deleteTile;
	final int index;

	const TotpWidget({ Key? key, required this.userDetails, required this.deleteTile, required this.index }) : super(key: key);

	@override
	_TotpWidgetState createState() => _TotpWidgetState();
}

class _TotpWidgetState extends State<TotpWidget> 
{
	// TODO: stop timer when not needed and initialize timer and totp and stuff when needed
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
	}

	@override
	void dispose()
	{
		stopTimer();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) 
	{
		timer = Timer.periodic(const Duration(seconds: 1), (_)
		{
			setState(()
			{
				unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
				if ((unixTime % 30) == 0)
				{
					totp = TOTP.generateTOTP(widget.userDetails.secretKey, unixTime);
				}
				timeRemaining = 30 - (unixTime % 30);
			});
		});

		return ListTile(
			//key      : widget.key,
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
			trailing: IconButton(
				icon: const Icon(Icons.delete_outline, color: appColor),
				color: buttonColor,
				onPressed: () => _delete(context),
			),
		);
	}
	
	void stopTimer()
	{
		setState(() => timer?.cancel());
	}

	void _delete(BuildContext context) 
	{
		showDialog(
			context: context,
			builder: (BuildContext ctx) 
			{
				return AlertDialog(
					key    : UniqueKey(),
					title  : Text('Please Confirm', style: Theme.of(context).textTheme.headline3),
					content: Text('Are you sure you want to remove this TOTP?', style: Theme.of(context).textTheme.bodyText1),
					backgroundColor: buttonColor,
					actions: <Widget> [
						TextButton( // "Yes" button
							child: Text('Yes', style: Theme.of(context).textTheme.bodyText1),
							onPressed: ()
							{
								Navigator.of(context).pop(); // Close the dialog
								widget.deleteTile(widget.index);
							},
						),
						TextButton( // "No" button
							child: Text('No', style: Theme.of(context).textTheme.bodyText1),
							onPressed: () => Navigator.of(context).pop(), // Close the dialog
						),
					],
				);
			}
		);
	}
}