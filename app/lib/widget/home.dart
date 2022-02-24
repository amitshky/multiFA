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
	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 0),
			body  : Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: const <Widget>[
						TotpWidget(),
					],
				),
			),
			//floatingActionButton: const ScanQRPage(), // Currently the QR code scanner doesnt do anything
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