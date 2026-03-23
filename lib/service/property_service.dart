import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../api/api_config.dart';
import '../model/property_model.dart';

class PropertyService {
  // ✅ POST PROPERTY
  Future<bool> addPropertyWithMedia({
    required Map<String, String> fields,
    List<File>? images,
    File? video,
  }) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.addProperty}");

      print("📡 MULTIPART URL: $url");
      print("📤 FIELDS: $fields");

      var request = http.MultipartRequest("POST", url);

      /// HEADERS (optional but good)
      request.headers.addAll({
        "Accept": "application/json",
      });

      /// TEXT FIELDS
      request.fields.addAll(fields);

      /// MULTIPLE IMAGES
      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "PropertyImage", // ⚠️ confirm backend key
              img.path,
            ),
          );
        }
      }

      /// VIDEO
      if (video != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "Video",
            video.path,
          ),
        );
      }

      /// SEND REQUEST
      final response = await request.send();

      final resBody = await response.stream.bytesToString();

      print("📦 STATUS: ${response.statusCode}");
      print("📦 RESPONSE: $resBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Upload Failed: $resBody");
      }
    } catch (e) {
      print("❌ MULTIPART ERROR: $e");
      rethrow;
    }
  }

  // ✅ GET PROPERTY
  Future<List<PropertyModel>> getProperties(String phone) async {
    try {
      final url =
          "${ApiConfig.baseUrl}${ApiConfig.getPropertyByPhone}?phone=$phone";

      print("📡 GET URL: $url");

      final response = await http.get(Uri.parse(url));

      print("📦 STATUS: ${response.statusCode}");
      print("📦 RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ FIX HERE
        final List data = decoded['data'];

        return data.map((e) => PropertyModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("❌ GET ERROR: $e");
      rethrow;
    }
  }
}
