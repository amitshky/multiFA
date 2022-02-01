import 'package:flutter/material.dart';

import 'package:app/style.dart';

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
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text('XXX XXX', style: Theme.of(context).textTheme.headline2),
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {},
				tooltip  : 'Scan QR code',
				child    : const Icon(Icons.add),
				backgroundColor: buttonColor,
				foregroundColor: appColor,
				elevation: 0,
			),
		);
	}
}