import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';

class TOTP
{
	// TODO: make generation async maybe

	static String generateTOTP(String secretStr, int unixTime)
	{
		int unixTimestep = (unixTime / 30).floor();
		List<int> unixTimestepBytes = _intToByteArray(unixTimestep);

		Hmac hmac = Hmac(sha1, base32.decode(secretStr));
		List<int> hashBytes = hmac.convert(unixTimestepBytes).bytes;

		int offset = hashBytes[hashBytes.length - 1] & 0xf;
		int rHex   = ((hashBytes[offset    ] & 0x7f) << 24) | 
								 ((hashBytes[offset + 1] & 0xff) << 16) | 
								 ((hashBytes[offset + 2] & 0xff) <<  8) | 
								 ((hashBytes[offset + 3] & 0xff));

		return (rHex % 1000000).toString().padLeft(6, '0');
	}

	static List<int> _intToByteArray(int val) 
	{
		List<int> byteArray = [0, 0, 0, 0, 0, 0, 0, 0];

		for (int i = 7; i >= 0; i--) 
		{
			byteArray[i] = val & 0xff;
			val >>= 8 ;
		}

		return byteArray;
	}
}