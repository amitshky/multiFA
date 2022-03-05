class UserDetails
{
	final String email;
	final String secretKey;
	final String multiFactorOptions;

	UserDetails({ required this.multiFactorOptions, required this.email, required this.secretKey });

	factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
		multiFactorOptions: json['multiFactorOptions'] as String,
		email             : json['email']     as String,
		secretKey         : json['secretKey'] as String
	);

	Map<String, dynamic> toJson()
	{
		return <String, dynamic>{ 'multiFactorOptions': multiFactorOptions, 'email': email, 'secretKey': secretKey };
	}

	@override
	String toString() => 'UserDetails{multiFactorOptions: $multiFactorOptions, email: $email, secretKey: $secretKey}';
}