class UserDetails
{
	final String email;
	final String secretKey;

	UserDetails({ required this.email, required this.secretKey });

	factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
		email     : json['email']     as String,
		secretKey : json['secretKey'] as String
	);

	Map<String, dynamic> toJson()
	{
		return <String, dynamic>{ 'email': email, 'secretKey': secretKey };
	}

	@override
	String toString() => 'UserDetails{email: $email, secretKey: $secretKey}';
}