import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_colors.dart';

class AgentDeveloperPage extends StatefulWidget {
  const AgentDeveloperPage({super.key});

  @override
  State<AgentDeveloperPage> createState() => _AgentDeveloperPageState();
}

class _AgentDeveloperPageState extends State<AgentDeveloperPage> {

  final _formKey = GlobalKey<FormState>();

  String selectedRole = "Agent";

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final reraController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    reraController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text(
          'Join Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// Profile Image
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightBlue,
                  backgroundImage:
                  selectedImage != null ? FileImage(selectedImage!) : null,
                  child: selectedImage == null
                      ? const Icon(Icons.camera_alt,
                      size: 40, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              /// Select Role
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: inputDecoration("Select Role"),
                items: const [
                  DropdownMenuItem(value: "Agent", child: Text("Agent")),
                  DropdownMenuItem(value: "Developer", child: Text("Developer")),
                  DropdownMenuItem(value: "Builder", child: Text("Builder")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),

              const SizedBox(height: 12),

              buildTextField("Name", nameController),
              buildTextField("Mobile No", mobileController,
                  keyboardType: TextInputType.phone),
              buildTextField("Email Id", emailController,
                  keyboardType: TextInputType.emailAddress),
              buildTextField("State", stateController),
              buildTextField("City", cityController),
              buildTextField("Address", addressController),
              buildTextField("Pincode", pincodeController,
                  keyboardType: TextInputType.number),

              /// Show RERA only if Developer or Builder
              if (selectedRole == "Developer" ||
                  selectedRole == "Builder")
                buildTextField("RERA No", reraController),

              buildTextField("Password", passwordController,
                  obscureText: true),

              const SizedBox(height: 25),

              /// Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      if (selectedRole == "Agent") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AgentSubscriptionPage(),
                          ),
                        );

                      } else if (selectedRole == "Developer" ||
                          selectedRole == "Builder") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PostingPaymentPage(),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Register",
                    style:
                    TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Common TextField
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
        decoration: inputDecoration(label),
      ),
    );
  }

  /// Common Decoration
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textLight),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
        const BorderSide(color: AppColors.primaryBlue),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

/// ------------------ Dummy Screens ------------------

class AgentSubscriptionPage extends StatelessWidget {
  const AgentSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agent Subscription")),
      body: const Center(
        child: Text("Agent Subscription Plan Screen"),
      ),
    );
  }
}

class PostingPaymentPage extends StatelessWidget {
  const PostingPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posting Payment")),
      body: const Center(
        child: Text("Developer/Builder Posting Payment Screen"),
      ),
    );
  }
}