import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_colors.dart';

class AddPropertiesPage extends StatefulWidget {
  const AddPropertiesPage({Key? key}) : super(key: key);

  @override
  State<AddPropertiesPage> createState() =>
      _AddPropertiesPage();
}

class _AddPropertiesPage
    extends State<AddPropertiesPage> {

  int currentStep = 1;
  String selectedCategory = "Sale";
  bool hideNumber = false;
  final List<String> selectedAmenities = [];

  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  File? selectedVideo;

  Future<void> pickImageFromCamera() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> pickVideoFromCamera() async {
    final XFile? video =
    await _picker.pickVideo(source: ImageSource.camera);

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

  final List<String> bhkList = [
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK"
  ];

  final List<String> statesList = [
    "Uttar Pradesh",
    "Madhya Pradesh",
    "Delhi",
    "Rajasthan",
    "Bihar",
    "Gujarat",
    "Maharashtra",
    "Punjab",
    "Haryana",
  ];


  String? selectedState;
  String? selectedType;
  String? selectedBhk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Property",
            style: TextStyle(color: Colors.white)),
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
                _textField("Property Title"),
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

                _textField("Price", prefix: "₹"),
                const SizedBox(height: 12),

                _textField("Area (Sqft)"),
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
                    value: selectedState,
                    decoration: InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primaryBlue),
                      ),
                    ),
                    items: statesList.map((state) {
                      return DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _textField("City"),
                  const SizedBox(height: 12),
                  _textField("Locality"),
                  const SizedBox(height: 12),
                  _textField("Landmark (Optional)"),
                  const SizedBox(height: 12),
                  _textField("Pincode"),
                ],
              ),
            ),

            const SizedBox(height: 16),

          _card(
            title: "Upload Photos & Video",
            icon: Icons.photo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= MEDIA BUTTONS =================
                Row(
                  children: [
                    _mediaBox("+ Add Photos"),
                    const SizedBox(width: 10),
                    _mediaBox("+ Upload Video"),
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
                      maxLines: 3),
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
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text("Pawan Kumar",
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold)),
                      Text("+91 9876543211"),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Hide Number"),
                      Switch(
                        activeColor:
                        AppColors.primaryOrange,
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

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primaryOrange,
                ),
                onPressed: () {
                  final newProperty = {
                    "id":
                    "PR-${DateTime.now().millisecondsSinceEpoch}",
                    "title": "New Property",
                    "location":
                    selectedState ?? "Unknown",
                    "price": "₹50,00,000",
                    "status": "Active",
                    "date":
                    "${DateTime.now().day} "
                        "${DateTime.now().month} "
                        "${DateTime.now().year}",
                  };

                  Navigator.pop(
                      context, newProperty);
                },
                child: const Text(
                  "Submit Property",
                  style:
                  TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: AppColors.primaryBlue),
                const SizedBox(width: 6),
                Text(title,
                    style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.primaryBlue)),
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
      {String? prefix, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.primaryBlue),
          borderRadius:
          BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
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
          borderSide: const BorderSide(
              color: AppColors.primaryBlue),
          borderRadius:
          BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
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
    return
      Row(
        children: [
          Icon(Icons.category,color: AppColors.primaryBlue,),
          SizedBox(width: 5,),
                Text('Categories',style: TextStyle(color: AppColors.primaryBlue),),
          SizedBox(width: 20,),
          /// SALE
          ChoiceChip(
            label: Text(
              "Sale",
              style: TextStyle(
                color: selectedCategory == "Sale"
                    ? Colors.white                 // Selected text
                    : AppColors.primaryBlue,       // Unselected text
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

          // const SizedBox(width: 10),
          //
          // /// RENT
          // ChoiceChip(
          //   label: Text(
          //     "Rent",
          //     style: TextStyle(
          //       color: selectedCategory == "Rent"
          //           ? Colors.white
          //           : AppColors.primaryBlue,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          //   selected: selectedCategory == "Rent",
          //   selectedColor: AppColors.primaryBlue,
          //   backgroundColor: AppColors.background,
          //   side: const BorderSide(
          //     color: AppColors.primaryBlue,
          //   ),
          //   onSelected: (_) {
          //     setState(() {
          //       selectedCategory = "Rent";
          //     });
          //   },
          // ),
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
          pickVideoFromCamera();  // 👈 YAHAN VIDEO PICK HOGA
          }
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.primaryBlue),
            borderRadius:
            BorderRadius.circular(8),
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
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.grey,
          ),
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.grey,
            ),
            const SizedBox(width: 6,),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryBlue
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
