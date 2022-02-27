import 'package:app/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/widgets/totp.dart';
import 'package:app/widgets/scanqr.dart';
import 'package:app/widgets/fingerprint.dart';
import 'package:app/models/userdetails.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/user_secure_storage.dart';


class HomeScreen extends StatefulWidget 
{
	final String title;
	const HomeScreen({ Key? key, required this.title }) : super(key: key);

	@override
	_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
	List<TotpWidget> totpTiles = <TotpWidget>[];

	List<UserDetails> userDetailsList = <UserDetails>[
		//UserDetails(email: 'amit@amit.com',           secretKey: 'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA'), 
		//UserDetails(email: 'heroku@heroku.com',       secretKey: 'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ'), 
		//UserDetails(email: 'kushal@shrestha.com',     secretKey: 'NVDGO3RKF43ES2DHORGUK6C2GBLF4ULENROTIVK3H5FGW5LDJY2A'), 
		//UserDetails(email: 'igotnthtolose@gmail.com', secretKey: 'KZHTETTSFRRHK5CJNQZEYQSKNMRUMWDBKI3XWVB4OM4FA4ZQKVSA'), 
	];

	Set<String> idSet = <String>{
		//'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA',
		//'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ',
		//'NVDGO3RKF43ES2DHORGUK6C2GBLF4ULENROTIVK3H5FGW5LDJY2A',
		//'KZHTETTSFRRHK5CJNQZEYQSKNMRUMWDBKI3XWVB4OM4FA4ZQKVSA',
	};

	@override
	void initState()
	{
		super.initState();
		_loadData(); // done to synchornize during initialization
	}

	@override
	void dispose()
	{
		_storeData(); // locally store user details (email and secret key)
		super.dispose();
	}

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
				children: <Widget>[ 
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
			_storeData(); // locally store user details (email and secret key)
		});
	}

	void _getQRData(String data) // data is an otpauth uri
	{
		setState(() 
		{
			final uriDecoded = otpauthUriDecode(data);
			if (uriDecoded  != null)
			{
				final item = UserDetails(email: uriDecoded['email']!, secretKey: uriDecoded['secretKey']!);

				if (idSet.add(item.secretKey))
				{
					userDetailsList.add(item);
				_storeData(); // locally store user details (email and secret key)
				}
				else
				{
					Fluttertoast.showToast(msg: 'This TOTP already exists.', backgroundColor: buttonColor);
				}
			}
			else
			{
				Fluttertoast.showToast(msg: 'Unrecognized OTPAuth URI.', backgroundColor: buttonColor);
			}
		});
	}

	Future<void> _loadData() async
	{
		await UserSecureStorage.load() // load user details (email and secret key) from local storage
			.then((value) => userDetailsList = value ?? <UserDetails>[])
			.whenComplete(()
			{
				for (int i = 0; i < userDetailsList.length; ++i)
				{
					if (!idSet.add(userDetailsList[i].secretKey))
					{
						userDetailsList.removeAt(i); // remove if duplicate
					}
				}
			});
		setState(() {}); // screen not updating after initState() without this
	}

	Future<void> _storeData() async
	{
		UserSecureStorage.save(userDetailsList); // locally store user details (email and secret key)
		setState(() {}); // just to make sure the state is updated // probably not needed
	}
}