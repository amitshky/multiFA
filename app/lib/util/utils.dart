Map<String, String>? otpauthUriDecode(String uri)
{
	if (uri.indexOf('otpauth://totp/') == 0) // check if the uri is in the correct format
	{
		final String key   = uri.substring(uri.indexOf('=') + 1);
		final String email = uri.substring(uri.indexOf('totp/') + 5, uri.indexOf('?'));
		return { 'email': email, 'key': key };
	}
	
	return null; 
}