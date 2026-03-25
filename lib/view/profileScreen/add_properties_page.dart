import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/admin_profile_controller.dart';
import '../../controller/property_controller.dart';
import '../../utils/app_colors.dart';

class AddPropertiesPage extends StatefulWidget {
  const AddPropertiesPage({Key? key}) : super(key: key);

  @override
  State<AddPropertiesPage> createState() => _AddPropertiesPage();
}

class _AddPropertiesPage extends State<AddPropertiesPage> {
  final storage = FlutterSecureStorage();
  final profileController = Get.find<AdminProfileController>();
  final controller = PropertyController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final descController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  int currentStep = 1;
  String selectedCategory = "Sale";
  bool hideNumber = false;
  final List<String> selectedAmenities = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadUserPhone();
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   loadUserData();
  // }
  @override
  void initState() {
    super.initState();

    final profile = profileController.profile.value;

    if (profile != null) {
      nameController.text = profile.agentName ?? "";
      emailController.text = profile.emailId ?? "";
      phoneController.text = profile.mobileNumber ?? "";
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  File? selectedVideo;

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      setState(() {
        selectedVideo = File(video.path);
      });
    }
  }

  final List<String> propertyTypes = [
    "Apartment",
    "Villa",
    "Plot",
    "Office",
    "Flat"
  ];

  final List<String> bhkList = ["1 BHK", "2 BHK", "3 BHK", "4 BHK"];

  final List<String> statesList = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  String? selectedState;
  String? selectedType;
  String? selectedBhk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Add Property", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _card(
              title: "Basic Details",
              icon: Icons.home,
              child: Column(
                children: [
                  _textField("Property Title", controller: titleController),
                  const SizedBox(height: 12),

                  _dropdown(
                    label: "Property Type",
                    value: selectedType,
                    items: propertyTypes,
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;

                        // Agar Flat nahi hai to BHK reset ho jaye
                        if (selectedType != "Flat") {
                          selectedBhk = null;
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 12),
                  _categoryToggle(),
                  const SizedBox(height: 12),

                  _textField("Price", prefix: "₹", controller: priceController),
                  const SizedBox(height: 12),

                  _textField("Area (Sqft)", controller: areaController),

                  const SizedBox(height: 12),

                  // 👇 YAHI MAIN CHANGE HAI
                  if (selectedType == "Flat") ...[
                    _dropdown(
                      label: "BHK",
                      value: selectedBhk,
                      items: bhkList,
                      onChanged: (val) {
                        setState(() {
                          selectedBhk = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              title: "Location Details",
              icon: Icons.location_on,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedState,
                    decoration: InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryBlue),
                      ),
                    ),
                    items: statesList.map((state) {
                      return DropdownMenuItem(
                        value: state,
                        child: Text(
                          state,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) {
                      return statesList.map((state) {
                        return Text(
                          state,
                          overflow: TextOverflow.ellipsis,
                        );
                      }).toList();
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _textField("City", controller: cityController),
                  const SizedBox(height: 12),
                  _textField("Locality"),
                  const SizedBox(height: 12),
                  _textField("Landmark (Optional)"),
                  const SizedBox(height: 12),
                  _textField("Pincode", controller: pincodeController),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              title: "Add Photos & Video",
              icon: Icons.photo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= MEDIA BUTTONS =================
                  Row(
                    children: [
                      _mediaBox("+ Add Photos"),
                      const SizedBox(width: 10),
                      _mediaBox("+ Add Video"),
                    ],
                  ),

                  /// ================= IMAGE PREVIEW =================
                  if (selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                /// IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImages[index],
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// ❌ REMOVE BUTTON
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  /// ================= VIDEO PREVIEW =================
                  if (selectedVideo != null) ...[
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.videocam,
                            color: AppColors.primaryBlue,
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              "Video Selected",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          /// ❌ REMOVE VIDEO
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedVideo = null;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              title: "Description & Amenities",
              icon: Icons.description,
              child: Column(
                children: [
                  _textField("Property Description",
                      maxLines: 3, controller: descController),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _amenityChip("Parking"),
                      _amenityChip("Lift"),
                      _amenityChip("CCTV"),
                      _amenityChip("Security"),
                      _amenityChip("Garden"),
                      _amenityChip("Gym"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              title: "Contact Details",
              icon: Icons.person,
              child: Column(
                children: [
                  _textField(
                    "Full Name *",
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    "Phone Number",
                    controller: phoneController,
                    enabled: !hideNumber,
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    "Email *",
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Hide Number"),
                      Switch(
                        activeColor: AppColors.primaryOrange,
                        value: hideNumber,
                        onChanged: (val) {
                          setState(() {
                            hideNumber = val;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            // _card(
            //   title: "Contact Details",
            //   icon: Icons.person,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text("Pawan Kumar",
            //               style: TextStyle(fontWeight: FontWeight.bold)),
            //           Text("+91 9876543211"),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           const Text("Hide Number"),
            //           Switch(
            //             activeColor: AppColors.primaryOrange,
            //             value: hideNumber,
            //             onChanged: (val) {
            //               setState(() {
            //                 hideNumber = val;
            //               });
            //             },
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                ),
                onPressed: () async {
                  String? phone = await storage.read(key: "phone");

                  final fields = {
                    "PropertyTitle": titleController.text,
                    "PropertyDescription": descController.text,
                    "Status": selectedCategory,
                    "PropertyType": selectedType ?? "Flat",
                    "Rooms": "2",
                    "Bathrooms": "1",
                    "Price": priceController.text,
                    "Area": areaController.text,
                    "PropertyAge": "5",
                    "PropertyFeatures": selectedAmenities.join(", "),
                    "City": cityController.text,
                    "State": selectedState ?? "Delhi",
                    "Country": "India",
                    "Latitude": "28.6139",
                    "Longitude": "77.2090",
                    "ContactName": nameController.text,
                    "Username": nameController.text,
                    "Email": emailController.text,

                    // 🔥 FINAL FIX
                    "Phone": hideNumber
                        ? "" // ya "hidden"
                        : (phone ?? phoneController.text),

                    "FlatBHK": selectedBhk ?? "",
                    "PinCode": pincodeController.text,
                    "CreatedById": "1"
                  };

                  try {
                    final success = await controller.addPropertyWithMedia(
                      fields: fields,
                      images: selectedImages,
                      video: selectedVideo,
                    );

                    if (success) {
                      if (!mounted) return;

                      showSuccessDialog(context); // ✅ ONLY THIS
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ ${controller.error}")),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Error: $e")),
                    );
                  }
                },
                child: const Text(
                  "Submit Property",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryBlue),
                const SizedBox(width: 6),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue)),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _textField(String label,
      {String? prefix,
      int maxLines = 1,
      TextEditingController? controller,
      bool enabled = true}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _categoryToggle() {
    return Row(
      children: [
        Icon(
          Icons.category,
          color: AppColors.primaryBlue,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'Categories',
          style: TextStyle(color: AppColors.primaryBlue),
        ),
        SizedBox(
          width: 20,
        ),

        /// SALE
        ChoiceChip(
          label: Text(
            "Sale",
            style: TextStyle(
              color: selectedCategory == "Sale"
                  ? Colors.white // Selected text
                  : AppColors.primaryBlue, // Unselected text
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: selectedCategory == "Sale",
          selectedColor: AppColors.primaryBlue,
          backgroundColor: AppColors.background,
          side: const BorderSide(
            color: AppColors.primaryBlue,
          ),
          onSelected: (_) {
            setState(() {
              selectedCategory = "Sale";
            });
          },
        ),
      ],
    );
  }

  Widget _mediaBox(String text) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (text == "+ Add Photos") {
            pickImageFromCamera();
          } else if (text == "+ Upload Video") {
            pickVideoFromCamera(); // 👈 YAHAN VIDEO PICK HOGA
          }
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryBlue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _amenityChip(String label) {
    final bool isSelected = selectedAmenities.contains(label);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedAmenities.remove(label);
          } else {
            selectedAmenities.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey,
          ),
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: isSelected ? AppColors.primaryBlue : Colors.grey,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryBlue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ✅ ICON
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryOrange,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Success 🎉",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const SizedBox(height: 10),

                /// MESSAGE
                const Text(
                  "Your property has been added successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textLight),
                ),

                const SizedBox(height: 20),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context, true); // go back
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
