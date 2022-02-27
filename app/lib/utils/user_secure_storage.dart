import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app/utils/utils.dart';
import 'package:app/models/userdetails.dart';

class UserSecureStorage
{
	static const _storage = FlutterSecureStorage();
	static const _key     = 'userDetailsList';

	static Future<void> save(List<UserDetails> list) async
	{
		return await _storage.write(key: _key, value: userDetailsListToJson(list));
	}

	static Future<List<UserDetails>?> load() async
	{
		final value = await _storage.read(key: _key);
		return jsonToUserDetailsList(value);
	}
}