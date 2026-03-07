import 'package:dtbroker_agent/utils/app_colors.dart';
import 'package:dtbroker_agent/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/admin_profile_controller.dart';
import 'controller/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AdminProfileController(), permanent: true);

  final AuthController controller =
  Get.put(AuthController());

  await controller.checkLogin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nivesh agent',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,

        // Primary Brand Colors
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryBlue,
          secondary: AppColors.primaryOrange,
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.primaryBlue,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}



