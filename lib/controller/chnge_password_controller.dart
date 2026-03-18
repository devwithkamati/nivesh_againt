import 'package:dtbroker_agent/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../service/change_password_service.dart';
import '../view/profileScreen/profile_page.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordService _service = ChangePasswordService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  RxBool isLoading = false.obs;

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;
      final id = await _storage.read(key: "agentId");
      if (id == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final response = await _service.changePassword(
        agentId: int.parse(id),
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (response != null && response.status) {
        // ✅ Success Snackbar
        Get.snackbar(
          "Success",
          response.message,
          backgroundColor: AppColors.primaryOrange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
        );

        // ✅ Navigate to Profile Screen
        Future.delayed(const Duration(milliseconds: 800), () {
          Get.offAll(() => ProfilePage());
        });
      } else {
        Get.snackbar("Error", response?.message ?? "Change password failed");
      }
    } catch (e) {
      print("🔥 Change Password Error: $e");

      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
