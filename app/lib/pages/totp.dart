import 'dart:async';
import 'package:flutter/material.dart';

import 'package:app/api/totp_api.dart';
import 'package:app/style.dart';

class TotpPage extends StatefulWidget 
{
	const TotpPage({ Key? key }) : super(key: key);

	@override
	_TotpPageState createState() => _TotpPageState();
}

class _TotpPageState extends State<TotpPage> 
{
	Timer? timer;
	// TODO: stop timer when not needed and initialize timer and totp and stuff when needed
	int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
	String totp  = TOTP.generateTOTP(DateTime.now().millisecondsSinceEpoch ~/ 1000);
	int timeRemaining = 30 - ((DateTime.now().millisecondsSinceEpoch ~/ 1000) % 30);

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
					totp = TOTP.generateTOTP(unixTime);
				}
				timeRemaining = 30 - (unixTime % 30);
			});
		});
		
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: [
				Text(totp.substring(0, 3) + ' ' + totp.substring(3), style: Theme.of(context).textTheme.headline2), 
				const SizedBox(width: 35),
				SizedBox(
					width : 28,
					height: 28,
					child: Stack(
						fit: StackFit.expand,
						children: [
							Center(child: Text('$timeRemaining', style: Theme.of(context).textTheme.bodyText2)),
							CircularProgressIndicator(
								value: 1 - (timeRemaining / 30),
								backgroundColor: Colors.white12,
								color: appColor,
								strokeWidth: 2,
							)
						],
					),
				),
			],
		);
	}
	
	void stopTimer()
	{
		setState(() => timer?.cancel());
	}
}