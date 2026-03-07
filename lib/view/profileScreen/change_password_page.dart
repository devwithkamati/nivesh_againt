import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chnge_password_controller.dart';
import '../../utils/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordPage> {

  final _formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final controller = Get.put(ChangePasswordController());

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Change Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Enter your current password and set a new secure password.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [

                  _passwordField(
                    controller: oldPasswordController,
                    label: "Old Password",
                    obscure: obscureOld,
                    toggle: () {
                      setState(() {
                        obscureOld = !obscureOld;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  _passwordField(
                    controller: newPasswordController,
                    label: "New Password",
                    obscure: obscureNew,
                    toggle: () {
                      setState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  _passwordField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    obscure: obscureConfirm,
                    toggle: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                    isConfirm: true,
                  ),

                  const SizedBox(height: 50),

                  /// 🔥 BUTTON WITH LOADING
                  Obx(() =>
                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!
                            .validate()) {

                          controller.changePassword(
                            oldPasswordController.text
                                .trim(),
                            newPasswordController.text
                                .trim(),
                          );
                        }
                      },
                      child: const Text(
                        "CONFIRM CHANGE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {

        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }

        if (isConfirm &&
            value != newPasswordController.text) {
          return "Passwords do not match";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        AppColors.primaryBlue.withOpacity(0.05),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off
                : Icons.visibility,
            color: AppColors.primaryBlue,
          ),
          onPressed: toggle,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}