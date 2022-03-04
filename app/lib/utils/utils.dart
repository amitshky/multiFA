import 'dart:convert';

import 'package:app/models/userdetails.dart';


Map<String, String>? otpauthUriDecode(String uri)
{
	// the uri is a custom otpauth uri with the format: multifa://{multiFactorOptions}?email={email}&secret={secretKey}
	if (uri.indexOf('multifa://') == 0) // check if the uri is in the correct format
	{
		final String multiFactorOptions = uri.substring(uri.indexOf('multifa://') + 10, uri.indexOf('?'));
		final String email              = uri.substring(uri.indexOf('email=') + 6, uri.indexOf('&'));
		final String secretKey          = uri.substring(uri.indexOf('secret=') + 7);
		return { 'multiFactorOptions': multiFactorOptions, 'email': email, 'secretKey': secretKey };
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