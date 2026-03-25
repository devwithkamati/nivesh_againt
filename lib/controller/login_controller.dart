import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../model/login_model.dart';
import '../service/login_service.dart';
import '../view/homeScreen/dashboard_page.dart';
import '../view/loginScreen/login_page.dart';
import 'admin_profile_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  LoginResponse? userData;

  Future<void> login(String mobile, String password) async {
    print("🔵 LOGIN STARTED");

    try {
      isLoading.value = true;

      final response = await _authService.login(mobile, password);

      if (response != null && response.status) {
        userData = response;

        await _storage.write(
          key: "agentId",
          value: response.data?.agentId.toString(),
        );
        await _storage.write(
          key: "phone",

          value: response.data?.mobileNumber, // 🔥 IMPORTANT
        );
        await _storage.write(
          key: "name",
          value: response.data?.agentName, // check API field name
        );

        await _storage.write(
          key: "email",
          value: response.data?.emailId, // check API field name
        );
        String? name = await _storage.read(key: "name");
        String? email = await _storage.read(key: "email");

        print("STORED NAME: $name");
        print("STORED EMAIL: $email");
        print("📥 LOGIN PHONE: ${response.data?.mobileNumber}");

        final profileController = Get.find<AdminProfileController>();
        await profileController.fetchProfile(response.data!.agentId);
        isLoggedIn.value = true;

        print("➡ Navigating to Dashboard");

        Get.offAll(() => const DashboardPage());
      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Login failed",
        );
      }
    } catch (e) {
      print("🔥 LOGIN EXCEPTION: $e");

      Get.snackbar(
        "Error",
        "Something went wrong",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkLogin() async {
    String? id = await _storage.read(key: "agentId");

    isLoggedIn.value = id != null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();

    isLoggedIn.value = false;

    Get.offAll(() => const LoginPage());
  }
}
