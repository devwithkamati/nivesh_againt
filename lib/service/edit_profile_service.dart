import 'dart:convert';
import 'dart:io';
import 'package:dtbroker_agent/model/edit_profile_model.dart';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';

class EditProfileService {

  Future<void> updateProfile({
    required int agentId,
    required String name,
    required String mobile,
    required String email,
    required String gender,
    required String city,
    required String address,
    File? image,
  }) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.editProfile}"),
    );

    request.fields['AgentId'] = agentId.toString();
    request.fields['AgentName'] = name;
    request.fields['MobileNumber'] = mobile;
    request.fields['EmailId'] = email;
    request.fields['Gender'] = gender;
    request.fields['City'] = city;
    request.fields['Address'] = address;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'AgentImage',
          image.path,
        ),
      );
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    final body = jsonDecode(responseBody);

    if (body["Status"] != true) {
      throw Exception(body["Message"]);
    }
  }
}