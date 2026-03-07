import 'package:dtbroker_agent/view/loginScreen/agent_developer_page.dart';
import 'package:flutter/material.dart';
import '../../controller/login_controller.dart';
import '../homeScreen/dashboard_page.dart';
import 'forgot_password_page.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordHidden = true;
  final AuthController controller = Get.put(AuthController());
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    FocusScope.of(context).unfocus();

    if (_mobileController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  InputDecoration _inputDecoration(
      String label,
      IconData icon, {
        Widget? suffixIcon,   // 👈 optional suffix
      }) {
    return InputDecoration(
      labelText: label,

      /// PREFIX
      prefixIcon: Icon(icon, color: AppColors.primaryBlue),

      /// SUFFIX (Optional)
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: AppColors.primaryBlue.withOpacity(0.05),

      contentPadding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// 🔥 Logo
              Image.asset(
                'assets/images/niveshtital.png',
                height: 220,
                width: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Developer Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ================= MOBILE =================
                      const Text(
                        "Mobile",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          "Enter Mobile Number",
                          Icons.phone,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ================= PASSWORD =================
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextField(
                        controller: _passwordController,
                        obscureText: _isPasswordHidden,
                        decoration: _inputDecoration(
                          "Enter Password",
                          Icons.lock,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment:
                        Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const AgentDeveloperPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Agent & Developer",
                            style: TextStyle(
                              color:
                              AppColors.primaryBlue,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      /// Forgot Password
                      Align(
                        alignment:
                        Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color:
                              AppColors.primaryBlue,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                      const SizedBox(height: 30),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child:
                        Obx(() =>
                        controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            controller.login(
                              _mobileController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
