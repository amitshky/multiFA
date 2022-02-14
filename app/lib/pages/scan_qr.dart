import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:app/style.dart';

class ScanQRPage extends StatefulWidget 
{
	const ScanQRPage({Key? key}) : super(key: key);

	@override
	_ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage>
{
	String qrData = 'N/A';

	@override
	Widget build(BuildContext context)
	{
		return FloatingActionButton(
			onPressed: scanQR,
			tooltip  : 'Scan QR code',
			child    : const Icon(Icons.add, size: 30),
			backgroundColor: buttonColor,
			foregroundColor: appColor,
			elevation: 0,
		);
	}

	Future<void> scanQR() async
	{
		try
		{
			FlutterBarcodeScanner.scanBarcode(appColorHex, 'Cancel', true, ScanMode.QR)
				.then((value) => qrData = value); // TODO: maybe store `qrData` in a file
		}
		catch(e)
		{
			qrData = 'Unable to scan the QR code.'; // TODO: put some actual exception handling here, like a popup or something
		}
	}
}