import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi
{
	static final _auth = LocalAuthentication();

	static Future<bool> hasBiometrics() async 
	{
		try
		{
			return await _auth.canCheckBiometrics;
		}
		on PlatformException catch(_)
		{
			return false;
		}
	}

	static Future<bool> authenticate() async 
	{
		final isAvailable = await hasBiometrics();
		if (!isAvailable) return false;

		try
		{
			return await _auth.authenticate(
				localizedReason: 'Scan Fingerprint to Authenticate', 
				biometricOnly  : true,
				useErrorDialogs: true,
				stickyAuth     : true, // keeps authentication dialog 
			);
		}
		on PlatformException catch(_)
		{
			return false;
		}
	}
}