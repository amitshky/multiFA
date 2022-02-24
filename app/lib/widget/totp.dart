import 'dart:async';
import 'package:flutter/material.dart';

import 'package:app/api/totp_api.dart';
import 'package:app/style.dart';

class TotpWidget extends StatefulWidget 
{
	const TotpWidget({ Key? key, required this.secret }) : super(key: key);
	final String secret;

	@override
	_TotpWidgetState createState() => _TotpWidgetState();
}

class _TotpWidgetState extends State<TotpWidget> 
{
	// TODO: stop timer when not needed and initialize timer and totp and stuff when needed
	Timer? timer;
	late String secretStr;
	late int unixTime;
	late String totp;
	late int timeRemaining;

	_TotpWidgetState()
		:super()
	{
		secretStr     = widget.secret;
		unixTime      = DateTime.now().millisecondsSinceEpoch ~/ 1000;
		totp          = TOTP.generateTOTP(secretStr, unixTime);
		timeRemaining = 30 - (unixTime % 30);
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
					totp = TOTP.generateTOTP(secretStr, unixTime);
				}
				timeRemaining = 30 - (unixTime % 30);
			});
		});

		return ListTile(
			title    : Text(totp.substring(0, 3) + ' ' + totp.substring(3), style: Theme.of(context).textTheme.headline2), 
			subtitle : Text("amit@amit.com", style: Theme.of(context).textTheme.bodyText1,),
			tileColor: appBgColor,
			leading  : SizedBox(
				width : 32,
				height: 32,
				child : Stack(
					fit : StackFit.expand,
					children: [
						Center(child: Text('$timeRemaining', style: Theme.of(context).textTheme.bodyText2)),
						CircularProgressIndicator(
							value          : 1 - (timeRemaining / 30),
							backgroundColor: Colors.white12,
							color          : appColor,
							strokeWidth    : 2,
						)
					],
				),
			),
			trailing: IconButton(
				icon     : const Icon(Icons.delete, color: appColor),
				tooltip  : 'Delete this TOTP.',
				onPressed: () {},
			),
		);
	}
	
	void stopTimer()
	{
		setState(() => timer?.cancel());
	}
}