import 'dart:io';
import 'package:dtbroker_agent/view/profileScreen/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/id_proof_controller.dart';
import '../../utils/app_colors.dart';
class KycPage extends StatelessWidget {

  final String role;   // 👈 ADD THIS

  KycPage({super.key, required this.role});

  final IdProofController controller = Get.put(IdProofController());



  final RxInt currentStep = 0.obs;
  final RxString selectedDocument = "".obs;
  final RxList<bool> completedSteps = [false, false, false].obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: AppColors.primaryBlue,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Upload KYC",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // ================= STEP TABS =================
            SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _stepTab("Personal Details", 0)),
                  Expanded(child: _stepTab("ID Proof", 1)),
                  Expanded(child: _stepTab("Bank Details", 2)),
                ],
              ),
            ),
            const Divider(height: 1),

            // ================= BODY =================
            Expanded(
              child: Obx(
                    () => IndexedStack(
                  index: currentStep.value,
                  children: [
                    _personalDetailsPage(),
                    _idProofPage(),
                    _bankDetailsPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STEP TAB =================

  Widget _stepTab(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => currentStep.value = index,
        child: Obx(() {

          bool isActive = currentStep.value == index;
          bool isCompleted = completedSteps[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? AppColors.primaryOrange   // ✅ Completed = Orange
                      : isActive
                      ? AppColors.primaryBlue // ✅ Active = Blue
                      : AppColors.textLight,  // ❌ Default = Light Text
                ),
              ),
              const SizedBox(height: 6),

              /// INDICATOR LINE
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryOrange   // ✅ Completed = Orange
                      : isActive
                      ? AppColors.primaryBlue // ✅ Active = Blue
                      : Colors.transparent,   // ❌ Default invisible
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }




  // ================= PAGE 1 =================
  Widget _personalDetailsPage() {
    return _cardWrapper(
      child: Column(
        children: [
          _input("Name"),
          const SizedBox(height: 12),
          _input("Mobile"),
          const SizedBox(height: 12),
          _input("Email"),
          const SizedBox(height: 12),
          _input("Pincode"),
          const SizedBox(height: 30),

          _button("Next", () {

            // Simple validation example
            if (true) {  // yaha apni validation lagana

              completedSteps[0] = true;   // ✅ Mark Step 1 Complete
              currentStep.value = 1;      // Go to ID Proof

            }

          }),
        ],
      ),
    );
  }


// ================= PAGE 2 =================
  Widget _idProofPage() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ================= TITLE =================
          const Text(
            "KYC Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 25),

          /// ================= AADHAAR =================
          _sectionTitle("Aadhaar Card (Front & Back)"),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.aadhaarFront.value != null) {
                    return _imagePreview(
                      imageFile: controller.aadhaarFront.value!,
                      onDelete: controller.removeAadhaarFront,
                    );
                  }
                  return GestureDetector(
                    onTap: controller.pickAadhaarFront,
                    child: _uploadBox("Upload Front"),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  if (controller.aadhaarBack.value != null) {
                    return _imagePreview(
                      imageFile: controller.aadhaarBack.value!,
                      onDelete: controller.removeAadhaarBack,
                    );
                  }
                  return GestureDetector(
                    onTap: controller.pickAadhaarBack,
                    child: _uploadBox("Upload Back"),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 25),

          /// ================= PAN =================
          _sectionTitle("PAN Card (Front)"),
          const SizedBox(height: 15),

          Obx(() {
            if (controller.panImage.value != null) {
              return _imagePreview(
                imageFile: controller.panImage.value!,
                onDelete: controller.removePan,
              );
            }
            return GestureDetector(
              onTap: controller.pickPan,
              child: _uploadBox("Upload PAN Front"),
            );
          }),

          const SizedBox(height: 25),

          /// ================= RERA NUMBER =================
          _sectionTitle("RERA Number"),
          const SizedBox(height: 10),

          TextFormField(
            controller: controller.reraController,
            decoration: InputDecoration(
              hintText: "Enter RERA Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// ================= OFFICE BANNER =================
          _sectionTitle("Office Banner with Front Photo"),
          const SizedBox(height: 15),

          Obx(() {
            if (controller.officeBanner.value != null) {
              return _imagePreview(
                imageFile: controller.officeBanner.value!,
                onDelete: controller.removeOfficeBanner,
              );
            }
            return GestureDetector(
              onTap: controller.pickOfficeBanner,
              child: _uploadBox("Upload Office Banner"),
            );
          }),

          const SizedBox(height: 30),

          /// ================= NEXT BUTTON =================
          _button("Next", () {

            if (controller.aadhaarFront.value == null ||
                controller.aadhaarBack.value == null) {
              Get.snackbar("Error",
                  "Upload Aadhaar Front & Back",
                  backgroundColor: AppColors.primaryOrange,
                  colorText: Colors.white);
              return;
            }

            if (controller.panImage.value == null) {
              Get.snackbar("Error",
                  "Upload PAN Card",
                  backgroundColor: AppColors.primaryOrange,
                  colorText: Colors.white);
              return;
            }

            if (controller.reraController.text.isEmpty) {
              Get.snackbar("Error",
                  "Enter RERA Number",
                  backgroundColor: AppColors.primaryOrange,
                  colorText: Colors.white);
              return;
            }

            if (controller.officeBanner.value == null) {
              Get.snackbar("Error",
                  "Upload Office Banner",
                  backgroundColor: AppColors.primaryOrange,
                  colorText: Colors.white);
              return;
            }

            completedSteps[1] = true;
            completedSteps.refresh();
            currentStep.value = 2;
          }),
        ],
      ),
    );
  }

// ================= PAGE 3 =================
  Widget _bankDetailsPage() {
    final RxString accountType = "Saving".obs;

    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Enter Account Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Account Type",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 6),

          Obx(
                () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: accountType.value,
                isExpanded: true,
                underline: const SizedBox(),
                items: ["Saving", "Current"]
                    .map(
                      (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  accountType.value = value!;
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          _input("Account Holder Name"),
          const SizedBox(height: 12),
          _input("Account Number"),
          const SizedBox(height: 12),
          _input("Confirm Account Number"),
          const SizedBox(height: 12),
          _input("IFSC Code"),
          const SizedBox(height: 12),
          _input("Bank Location"),
          const SizedBox(height: 30),

          _button("Submit", () {

            // Optional validation laga sakte ho yaha

            completedSteps[2] = true;
            completedSteps.refresh();   // 🔥 important for UI update

            Get.snackbar(
              "Success",
              "KYC Submitted Successfully",
              backgroundColor: AppColors.primaryOrange,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(12),
              borderRadius: 12,
              duration: const Duration(seconds: 1),
            );
            // Delay before navigation
            Future.delayed(const Duration(seconds: 2), () {

              // Optional reset
              completedSteps.value = [false, false, false];
              currentStep.value = 0;

              // Navigate to main page
              Get.offAll(() => ProfilePage());

            });

          }),
        ],
      ),
    );
  }



  // ================= COMMON CARD =================

  Widget _cardWrapper({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _imagePreview({
    required File imageFile,
    required VoidCallback onDelete,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            imageFile,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
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
    );
  }

  // ================= INPUT =================

  Widget _input(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 6),

        TextField(
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }



  // ================= DOC TILE =================

  // Widget _docTile(String title) {
  //   return ListTile(
  //     leading: const Icon(
  //       Icons.description,
  //       color: AppColors.primaryBlue,
  //     ),
  //     title: Text(title),
  //     trailing: const Icon(
  //       Icons.arrow_forward_ios,
  //       size: 16,
  //       color: Colors.grey,
  //     ),
  //   );
  // }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 40,
          color: AppColors.primaryOrange,
        ),
      ],
    );
  }


  Widget _uploadBox(String text) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.upload_file,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }



  // ================= BUTTON =================

  Widget _docButton(String title) {
    return Expanded(
      child: Obx(
            () => GestureDetector(
          onTap: () {
            selectedDocument.value = title;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selectedDocument.value == title
                  ? AppColors.primaryBlue
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryBlue,
              ),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selectedDocument.value == title
                      ? Colors.white
                      : AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
