import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class IdProofController extends GetxController {

  final ImagePicker _picker = ImagePicker();

  /// ================= AADHAAR =================
  Rx<File?> aadhaarFront = Rx<File?>(null);
  Rx<File?> aadhaarBack = Rx<File?>(null);

  /// ================= PAN =================
  Rx<File?> panImage = Rx<File?>(null);

  /// ================= OFFICE BANNER =================
  Rx<File?> officeBanner = Rx<File?>(null);

  /// ================= RERA =================
  TextEditingController reraController = TextEditingController();

  /// ================= IMAGE PICK FUNCTION =================
  Future<File?> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// ================= AADHAAR METHODS =================
  Future<void> pickAadhaarFront() async {
    final file = await _pickImage();
    if (file != null) {
      aadhaarFront.value = file;
    }
  }

  Future<void> pickAadhaarBack() async {
    final file = await _pickImage();
    if (file != null) {
      aadhaarBack.value = file;
    }
  }

  void removeAadhaarFront() {
    aadhaarFront.value = null;
  }

  void removeAadhaarBack() {
    aadhaarBack.value = null;
  }

  /// ================= PAN METHODS =================
  Future<void> pickPan() async {
    final file = await _pickImage();
    if (file != null) {
      panImage.value = file;
    }
  }

  void removePan() {
    panImage.value = null;
  }

  /// ================= OFFICE BANNER METHODS =================
  Future<void> pickOfficeBanner() async {
    final file = await _pickImage();
    if (file != null) {
      officeBanner.value = file;
    }
  }

  void removeOfficeBanner() {
    officeBanner.value = null;
  }

  /// ================= CLEAR ALL (Optional) =================
  void clearAll() {
    aadhaarFront.value = null;
    aadhaarBack.value = null;
    panImage.value = null;
    officeBanner.value = null;
    reraController.clear();
  }
}