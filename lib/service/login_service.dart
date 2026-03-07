import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_config.dart';
import '../model/login_model.dart';


class AuthService {

  Future<LoginResponse?> login(
      String mobile,
      String password,
      ) async {

    final uri = Uri.parse(
        "${ApiConfig.baseUrl}${ApiConfig.login}"
    );
  print("Url is: $uri");
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "MobileNumber": mobile,
        "Password": password,
      }),
    );
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(
          jsonDecode(response.body));
    }

    return null;
  }
}