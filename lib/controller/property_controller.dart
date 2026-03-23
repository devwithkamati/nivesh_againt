import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../model/property_model.dart';
import '../service/property_service.dart';

class PropertyController extends ChangeNotifier {
  final PropertyService _service = PropertyService();

  bool isLoading = false;
  String error = "";

  List<PropertyModel> properties = [];

  // POST
  Future<bool> addPropertyWithMedia({
    required Map<String, String> fields,
    List<File>? images,
    File? video,
  }) async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      final result = await _service.addPropertyWithMedia(
        fields: fields,
        images: images,
        video: video,
      );

      return result;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET
  Future<void> fetchProperties(String phone) async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      properties = await _service.getProperties(phone);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
