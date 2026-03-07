import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';
import '../model/admin_profile_model.dart';

class AdminProfileService {

  Future<AdminProfileModel> getProfile(int agentId) async {

    final url =
        "${ApiConfig.baseUrl}${ApiConfig.agentProfile}?agentId=$agentId";

    print("API URL: $url");

    final response = await http.get(Uri.parse(url));

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      if (body["Status"] == true) {

        return AdminProfileModel.fromJson(body["Data"]);

      } else {
        throw Exception(body["Message"]);
      }

    } else {
      throw Exception("Failed to load profile");
    }
  }
}