import 'package:app/style.dart';
import 'package:app/widgets/fingerprint.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/widgets/totp.dart';
import 'package:app/widgets/scanqr.dart';
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
	final Set<String> _idSet = <String>{};
	List<UserDetails> _userDetailsList = <UserDetails>[];

	@override
	void initState()
	{
		super.initState();
		_loadData(); // done to synchornize during initialization
	}

	@override
	void dispose()
	{
		_saveData(); // locally store user details
		super.dispose();
	}

	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(title: Text(widget.title), centerTitle: true, elevation: 0),
			body  : ListView.separated(
				itemCount  : _userDetailsList.length,
				itemBuilder: (context, index) 
				{
					if (_userDetailsList[index].multiFactorOptions == 'fingerprint')
					{
						return FingerprintWidget(
							key        : UniqueKey(), 
							userDetails: _userDetailsList[index], 
							deleteTile : _deleteTile
						);
					}
					else 
					{
						return TotpWidget(
							key         : UniqueKey(), 
							userDetails : _userDetailsList[index], 
							deleteTile  : _deleteTile,
							hasBiometric: _userDetailsList[index].multiFactorOptions == 'both'
						);
					}
				},
				separatorBuilder: (context, index) => const Divider(color: dividerColor, indent: 16.0, endIndent: 16.0),
			),
			bottomNavigationBar: ScanQRPage(getQRData: _getQRData),
		);
	}

	void _deleteTile(UserDetails obj)
	{
		final idx = _userDetailsList.indexOf(obj);
		_idSet.remove(_userDetailsList[idx].secretKey);
		setState(() => _userDetailsList.removeAt(idx));
		_saveData(); // locally store user details
	}

	void _getQRData(String data) // data is an otpauth uri
	{
		final uriDecoded = otpauthUriDecode(data);
		if (uriDecoded  != null)
		{
			final item = UserDetails(multiFactorOptions: uriDecoded['multiFactorOptions']!, email: uriDecoded['email']!, secretKey: uriDecoded['secretKey']!);

			if (_idSet.add(item.secretKey))
			{
				setState(() => _userDetailsList.add(item));
				_saveData(); // locally store user details
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
	}

	Future<void> _loadData() async
	{
		await UserSecureStorage.load() // load user details (email and secret key) from local storage
			.then((value) => _userDetailsList = value ?? <UserDetails>[])
			.whenComplete(()
			{
				for (int i = 0; i < _userDetailsList.length; ++i)
				{
					if (!_idSet.add(_userDetailsList[i].secretKey))
					{
						_userDetailsList.removeAt(i); // remove if duplicate
					}
				}
			});

		setState(() {}); // screen not updating after initState() without this
	}

	Future<void> _saveData() async
	{
		UserSecureStorage.save(_userDetailsList); // locally store user details
		setState(() {}); // just to make sure the state is updated ; probably not needed
	}
}