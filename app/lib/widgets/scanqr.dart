import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:app/style.dart';

class ScanQRPage extends StatefulWidget 
{
	final void Function(String) getQRData;
	const ScanQRPage({ Key? key, required this.getQRData }) : super(key: key);

	@override
	_ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage>
{
	@override
	Widget build(BuildContext context)
	{
		return ElevatedButton.icon(
			icon : const Icon(Icons.add, size: 26, color: appColor),
			label: Text('Add TOTP', style: Theme.of(context).textTheme.bodyText1),
			style: ElevatedButton.styleFrom(
				primary  : appBgColor,
				elevation: 0,
			),
			onPressed: _scanQR,
		);
	}

	Future<void> _scanQR() async
	{
		try
		{
			FlutterBarcodeScanner.scanBarcode(appColorHex, 'Cancel', true, ScanMode.QR)
				.then((value) => setState(() => widget.getQRData(value)));
		}
		catch(_)
		{
			Fluttertoast.showToast(msg: 'Scan unsuccessful.', backgroundColor: buttonColor);
		}
	}
}