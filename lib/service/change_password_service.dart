import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_config.dart';
import '../model/change_password_model.dart';

class ChangePasswordService {

  Future<ChangePasswordResponse?> changePassword({
    required int agentId,
    required String oldPassword,
    required String newPassword,
  }) async {

    final uri = Uri.parse(
      "${ApiConfig.baseUrl}${ApiConfig.changePassword}",
    );

    print("🔵 Change Password URL: $uri");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "AgentId": agentId,
        "OldPassword": oldPassword,
        "NewPassword": newPassword,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      return ChangePasswordResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    return null;
  }
}