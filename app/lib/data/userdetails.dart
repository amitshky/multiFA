library globals;

class UserDetails
{
	final String email;
	final String secretKey;

	UserDetails({ required this.email, required this.secretKey });
}

List<UserDetails> userDetailsList = [
	UserDetails(email: 'amit@amit.com',           secretKey: 'MEWHQLCVJN2DWQTUNBFD47LTG4WDMP2PHF5DK23UENXDGNSKOQYA'), 
	UserDetails(email: 'heroku@heroku.com',       secretKey: 'JI2GYV2SHY2TA6L2LNQTAQSKHJLC4ZJRPJHGI4DLGI3XEZLPK5YQ'), 
	UserDetails(email: 'kushal@shrestha.com',     secretKey: 'NVDGO3RKF43ES2DHORGUK6C2GBLF4ULENROTIVK3H5FGW5LDJY2A'), 
	UserDetails(email: 'igotnthtolose@gmail.com', secretKey: 'KZHTETTSFRRHK5CJNQZEYQSKNMRUMWDBKI3XWVB4OM4FA4ZQKVSA'), 
];

