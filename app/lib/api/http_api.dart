import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class HttpApi
{
	static Future<void> sendVerification(String email, String secretKey) async
	{
		// this may seem stupid
		final token = JWT({ 'verified': true }).sign(SecretKey(secretKey), expiresIn: const Duration(minutes: 5));
		print(token);
		final http.Response res = await http.post(Uri.https('multifa.herokuapp.com', '/api/sessions/rec-3fa'), headers: { 'email': email }, body: { 'token': token });
		print(res.statusCode);
	}
}