import 'package:app/style.dart';
import 'package:flutter/material.dart';

import 'totp.dart';
import 'scanqr.dart';
import 'fingerprint.dart';

class HomePage extends StatefulWidget 
{
	final String title;
	const HomePage({Key? key, required this.title}) : super(key: key);

	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
	List<UserDetails> secretsList = [
		UserDetails(email: 'amit@amit.com',     secretKey: 'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA'), 
		UserDetails(email: 'heroku@heroku.com', secretKey: 'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ'), 
	];

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 0),
			body  : ListView.separated(
				itemCount       : secretsList.length,
				itemBuilder     : (context, index) => TotpWidget(email: secretsList[index].email, secret: secretsList[index].secretKey),
				separatorBuilder: (context, index) => const Divider(color: buttonColor, indent: 16.0, endIndent: 16.0),
			),
			bottomNavigationBar: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: const <Widget> [ 
					FingerprintWidget(), 
					ScanQRPage()
				]
			),
		);
	}
}

class UserDetails
{
	final String email;
	final String secretKey;

	UserDetails({ required this.email, required this.secretKey });
}