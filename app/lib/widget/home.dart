import 'package:app/style.dart';
import 'package:flutter/material.dart';

import 'totp.dart';
import 'scanqr.dart';
import 'fingerprint.dart';
import 'package:app/data/userdetails.dart';

class HomePage extends StatefulWidget 
{
	final String title;
	const HomePage({ Key? key, required this.title }) : super(key: key);

	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
	List<TotpWidget> totpListTile = [];

	@override
	void initState()
	{
		super.initState();
		for (int i = 0; i < userDetailsList.length; i++)
		{
			totpListTile.add(TotpWidget(userDetails: userDetailsList[i], deleteTile: deleteTile, index: i));
		}
	}

	@override
	void dispose()
	{
		// code here
		super.dispose();
	}

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 0),
			body  : ListView.separated(
				itemCount  : userDetailsList.length,
				itemBuilder: (context, index) => totpListTile[index],
				separatorBuilder: (context, index) => const Divider(color: dividerColor, indent: 16.0, endIndent: 16.0),
			),
			bottomNavigationBar: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: const <Widget> [ 
					FingerprintWidget(),
					ScanQRPage(),
				]
			),
		);
	}

	void deleteTile(int index)
	{
		setState(() => userDetailsList.removeAt(index));
	}
}