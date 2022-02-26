import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

	Set<String> idSet = <String> {
		'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA',
		'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ',
		'NVDGO3RKF43ES2DHORGUK6C2GBLF4ULENROTIVK3H5FGW5LDJY2A',
		'KZHTETTSFRRHK5CJNQZEYQSKNMRUMWDBKI3XWVB4OM4FA4ZQKVSA',
	};

	@override
	void initState()
	{
		super.initState();
		for (int i = 0; i < userDetailsList.length; ++i)
		{
			totpTiles.add(TotpWidget(
				key        : UniqueKey(), 
				userDetails: userDetailsList[i], 
				deleteTile : _deleteTile, 
				index      : i
			));
		}
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
			idSet.remove(userDetailsList[index].secretKey);
			userDetailsList.removeAt(index);
			totpTiles.removeAt(index);
		});
	}

	void _getQRData(String data) // data is an otpauth uri
	{
		setState(() 
		{
			final uriDecoded = _otpauthUriDecode(data);
			if (uriDecoded  != null)
			{
				final item = UserDetails(email: uriDecoded['email']!, secretKey: uriDecoded['key']!);

				if (idSet.add(item.secretKey))
				{
					totpTiles.add(TotpWidget(
						key: UniqueKey(),
						userDetails: item, 
						deleteTile : _deleteTile, 
						index      : totpTiles.length,
					));

					userDetailsList.add(item);
				}
				else
				{
					Fluttertoast.showToast(msg: 'This TOTP already exists.');
				}
			}
		});
	}

	Map<String, String>? _otpauthUriDecode(String uri)
	{
		if (uri.indexOf('otpauth://totp/') == 0) // check if the uri is in the correct format
		{
			final String key   = uri.substring(uri.indexOf('=') + 1);
			final String email = uri.substring(uri.indexOf('totp/') + 5, uri.indexOf('?'));
			return { 'email': email, 'key': key };
		}
		
		return null; 
	}
}