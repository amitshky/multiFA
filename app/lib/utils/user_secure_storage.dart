import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app/utils/utils.dart';
import 'package:app/models/userdetails.dart';

class UserSecureStorage
{
	static const _storage = FlutterSecureStorage();
	static const _totpKey        = 'totpUserDetailsList';
	static const _fingerprintKey = 'fingerprintUserDetailsList';

	static Future<void> save(List<UserDetails> list) async
	{
		return await _storage.write(key: _totpKey, value: userDetailsListToJson(list));
	}

	static Future<List<UserDetails>?> loadTotpUsers() async
	{
		final value = await _storage.read(key: _totpKey);
		return jsonToUserDetailsList(value);
	}

	static Future<List<UserDetails>?> loadFingerprintUsers() async
	{
		final value = await _storage.read(key: _fingerprintKey);
		return jsonToUserDetailsList(value);
	}
}