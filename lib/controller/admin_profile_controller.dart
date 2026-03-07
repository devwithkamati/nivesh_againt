import 'dart:io';
import 'package:dtbroker_agent/utils/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../model/admin_profile_model.dart';
import '../service/admin_profile_service.dart';
import '../service/edit_profile_service.dart';

class AdminProfileController extends GetxController {

  final AdminProfileService _service = AdminProfileService();
  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  RxBool isLoading = false.obs;
  Rx<AdminProfileModel?> profile =
  Rx<AdminProfileModel?>(null);
  RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadFromStorage();
  }

  Future<void> loadFromStorage() async {
    final id = await _storage.read(key: "agentId");
    if (id != null) {
      await fetchProfile(int.parse(id));
    }
  }

  Future<void> fetchProfile(int agentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final result = await _service.getProfile(agentId);
      profile.value = result;

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String mobile,
    required String email,
    required String gender,
    required String city,
    required String address,
    File? image,
  }) async {
    try {
      isLoading.value = true;

      final id = profile.value?.agentId;
      if (id == null) return;

      await EditProfileService().updateProfile(
        agentId: id,
        name: name,
        mobile: mobile,
        email: email,
        gender: gender,
        city: city,
        address: address,
        image: image,
      );

      // 🔥 Refresh profile after update
      await fetchProfile(id);

      await Future.delayed(Duration(microseconds: 300));

      Get.snackbar("Success", "Profile Updated",backgroundColor: AppColors.primaryOrange,colorText: AppColors.background);

    } catch (e) {
      Get.snackbar("Error", e.toString(),backgroundColor: AppColors.primaryOrange,colorText: AppColors.background);
    } finally {
      isLoading.value = false;
    }
  }
}