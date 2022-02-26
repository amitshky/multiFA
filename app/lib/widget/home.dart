import 'package:app/style.dart';
import 'package:flutter/material.dart';

import 'totp.dart';
import 'scanqr.dart';
import 'fingerprint.dart';
import 'package:app/model/userdetails.dart';

class HomePage extends StatefulWidget 
{
	final String title;
	const HomePage({ Key? key, required this.title }) : super(key: key);

	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
	List<TotpWidget> totpTiles = <TotpWidget>[];

	List<UserDetails> userDetailsList = [
		UserDetails(email: 'amit@amit.com',           secretKey: 'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA'), 
		UserDetails(email: 'heroku@heroku.com',       secretKey: 'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ'), 
		UserDetails(email: 'kushal@shrestha.com',     secretKey: 'NVDGO3RKF43ES2DHORGUK6C2GBLF4ULENROTIVK3H5FGW5LDJY2A'), 
		UserDetails(email: 'igotnthtolose@gmail.com', secretKey: 'KZHTETTSFRRHK5CJNQZEYQSKNMRUMWDBKI3XWVB4OM4FA4ZQKVSA'), 
	];

	@override
	void initState()
	{
		super.initState();
		for (int i = 0; i < userDetailsList.length; i++)
		{
			final item = userDetailsList[i];
			totpTiles.add(TotpWidget(key: UniqueKey(), userDetails: item, deleteTile: _deleteTile, index: i));
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
				itemCount  : totpTiles.length,
				itemBuilder: (context, index) => totpTiles[index],
				separatorBuilder: (context, index) => const Divider(color: dividerColor, indent: 16.0, endIndent: 16.0),
			),
			bottomNavigationBar: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: <Widget> [ 
					const FingerprintWidget(),
					ScanQRPage(getQRData: _getQRData),
				]
			),
		);
	}

	void _deleteTile(int index)
	{
		setState(() 
		{
			totpTiles.removeAt(index);
			userDetailsList.removeAt(index);
		});
	}

	void _getQRData(String data) // data is an otpauth uri
	{
		setState(() 
		{
			final obj  = _otpauthUriDecode(data);
			final item = UserDetails(email: obj['email']!, secretKey: obj['key']!);

			final totpItem = TotpWidget(
				key: UniqueKey(),
				userDetails: item, 
				deleteTile : _deleteTile, 
				index      : totpTiles.length
			);

			totpTiles.add(totpItem);
			userDetailsList.add(item);
		});
	}

	Map<String, String> _otpauthUriDecode(String uri)
	{
		// TODO: check if the data is in the right format
		final String key   = uri.substring(uri.indexOf('=') + 1);
		final String email = uri.substring(uri.indexOf('totp/') + 5, uri.indexOf('?'));
		return { 'email': email, 'key': key };
	}
}