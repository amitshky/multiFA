import 'dart:convert';

import 'package:app/models/userdetails.dart';

Map<String, String>? otpauthUriDecode(String uri)
{
	if (uri.indexOf('otpauth://totp/') == 0) // check if the uri is in the correct format
	{
		final String secretKey = uri.substring(uri.indexOf('=') + 1);
		final String email     = uri.substring(uri.indexOf('totp/') + 5, uri.indexOf('?'));
		return { 'email': email, 'secretKey': secretKey };
	}

	return null;
}

String userDetailsListToJson(List<UserDetails> list)
{
	return jsonEncode(list);
}

List<UserDetails> jsonToUserDetailsList(String? jsonData)
{
	if (jsonData != null)
	{
		Iterable itr = jsonDecode(jsonData);
		List<UserDetails> userDetailsList = List<UserDetails>.from(itr.map((model) => UserDetails.fromJson(model)));
		return userDetailsList;
	}

	return <UserDetails>[];
}