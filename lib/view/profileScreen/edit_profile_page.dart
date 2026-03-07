import 'dart:io';
import 'package:dtbroker_agent/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/admin_profile_controller.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final profileController = Get.find<AdminProfileController>();
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;

  final TextEditingController _agentName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _address = TextEditingController();
  String? _selectedGender;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {

      await profileController.updateProfile(
        name: _agentName.text,
        mobile: _phone.text,
        email: _email.text,
        gender: _selectedGender == "Male"
            ? "M"
            : _selectedGender == "Female"
            ? "F"
            : "O",
        city: _city.text,
        address: _address.text,
        image: _profileImage,
      );

      if (mounted) {
        Navigator.pop(context);  // safer
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final data = profileController.profile.value;

    if (data != null) {
      _agentName.text = data.agentName ?? "";
      _phone.text = data.mobileNumber ?? "";
      _email.text = data.emailId ?? "";
      _city.text = data.city ?? "";
      _address.text = data.address ?? "";

      _selectedGender = data.gender == "M"
          ? "Male"
          : data.gender == "F"
          ? "Female"
          : "Other";
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.primaryBlue.withOpacity(0.05),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: AppColors.primaryBlue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading:
      InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child:   Icon(Icons.arrow_back, color: Colors.white),
      ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
             const SizedBox(
               height: 20,
             ),
              /// 🔹 Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : profileController.profile.value?.agentImage != null
                          ? NetworkImage(
                          "https://niveshcore.com${profileController.profile.value!.agentImage}")
                          : const AssetImage("assets/images/profile_image.jpeg")
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding:
                          const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrange,
                          ),
                          child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Your Information",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                    AppColors.primaryBlue),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _agentName,
                decoration:
                _inputDecoration("Agent name"),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter Agent name"
                    : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _phone,
                keyboardType:
                TextInputType.phone,
                decoration:
                _inputDecoration("Phone"),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter phone number"
                    : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _email,
                keyboardType:
                TextInputType.emailAddress,
                decoration:
                _inputDecoration("Email Id"),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter email"
                    : null,
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration:
                _inputDecoration("Gender"),
                items: const [
                  DropdownMenuItem(
                      value: "Male",
                      child: Text("Male")),
                  DropdownMenuItem(
                      value: "Female",
                      child: Text("Female")),
                  DropdownMenuItem(
                      value: "Other",
                      child: Text("Other")),



                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                value == null
                    ? "Select gender"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _city,
                decoration:
                _inputDecoration("City name"),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter City name"
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _address,
                decoration:
                _inputDecoration("State name"),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter State"
                    : null,
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    minimumSize:
                    const Size(300, 50),
                    backgroundColor:
                    AppColors.primaryOrange,
                  ),
                 onPressed: _saveProfile,
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
