import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/widget/totp.dart';
import 'package:app/widget/scanqr.dart';
import 'package:app/widget/fingerprint.dart';
import 'package:app/model/userdetails.dart';
import 'package:app/utils/utils.dart';


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
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 0),
			body  : ListView.separated(
				itemCount  : userDetailsList.length,
				itemBuilder: (context, index) 
				{
					return TotpWidget(
						key        : UniqueKey(), 
						userDetails: userDetailsList[index], 
						deleteTile : _deleteTile,
					);
				},
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

	void _deleteTile(UserDetails obj)
	{
		setState(() 
		{
			final idx = userDetailsList.indexOf(obj);
			idSet.remove(userDetailsList[idx].secretKey);
			userDetailsList.removeAt(idx);
		});
	}

	void _getQRData(String data) // data is an otpauth uri
	{
		setState(() 
		{
			final uriDecoded = otpauthUriDecode(data);
			if (uriDecoded  != null)
			{
				final item = UserDetails(email: uriDecoded['email']!, secretKey: uriDecoded['key']!);

				if (idSet.add(item.secretKey))
				{
					userDetailsList.add(item);
				}
				else
				{
					Fluttertoast.showToast(msg: 'This TOTP already exists.');
				}
			}
			else
			{
				Fluttertoast.showToast(msg: 'Unrecognized OTPAuth URI.');
			}
		});
	}
}