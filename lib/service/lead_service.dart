import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/api_config.dart';
import '../model/lead_model.dart';

class LeadService {
  Future<List<LeadModel>> getLeads(String mobile) async {
    try {
      final url =
          "${ApiConfig.baseUrl}${ApiConfig.getLeadsByMobile}?mobile=$mobile";

      print("📡 API URL: $url");

      final response = await http.get(Uri.parse(url));

      print("📦 Status Code: ${response.statusCode}");
      print("📦 Response: ${response.body}");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        return data.map((e) => LeadModel.fromJson(e)).toList();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API ERROR: $e");
      rethrow;
    }
  }
}
