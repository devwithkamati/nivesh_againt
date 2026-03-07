import 'package:dtbroker_agent/controller/admin_profile_controller.dart';
import 'package:dtbroker_agent/view/homeScreen/dashboard_page.dart';
import 'package:dtbroker_agent/view/loginScreen/login_page.dart';
import 'package:dtbroker_agent/view/profileScreen/change_password_page.dart';
import 'package:dtbroker_agent/view/profileScreen/edit_profile_page.dart';
import 'package:dtbroker_agent/view/profileScreen/kyc_page.dart';
import 'package:dtbroker_agent/view/profileScreen/add_properties_page.dart';
import 'package:dtbroker_agent/view/profileScreen/latest_lead_page.dart';
import 'package:dtbroker_agent/view/profileScreen/myListing_page.dart';
import 'package:dtbroker_agent/view/profileScreen/postes_properties_page.dart';
import 'package:dtbroker_agent/view/profileScreen/subscription_page.dart';
import 'package:dtbroker_agent/view/profileScreen/wallet_page.dart';
import 'package:flutter/material.dart';
import '../../controller/login_controller.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileController = Get.find<AdminProfileController>();

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,

        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DashboardPage()));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),

        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.settings, color: Colors.white),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔹 PROFILE HEADER
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        Obx(() {
                          final profile = profileController.profile.value;

                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: profile?.agentImage != null
                                ? NetworkImage(
                                "https://niveshcore.com${profile!.agentImage}?t=${DateTime.now().millisecondsSinceEpoch}")
                                : const AssetImage('assets/images/profile_image.jpeg')
                            as ImageProvider,

                          );
                        }),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(6),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.primaryOrange,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: const Icon(
                        //       Icons.camera_alt,
                        //       size: 18,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

        Obx(() {

          if (profileController.isLoading.value) {
            return const CircularProgressIndicator();
          }

          final data = profileController.profile.value;

          if (data == null) {
            return const Text("No Profile Data");
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.agentName ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                data.emailId ?? "",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          );
        })]

              ),
            ),

            const SizedBox(height: 5),

            /// 🔹 EDIT PROFILE BUTTON
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔹 MENU ITEMS
            _buildMenuItem(Icons.verified_user, "KYC",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                         KycPage(role: '',)),
                  );
                }),

            _buildMenuItem(Icons.file_upload_outlined,
                "Post New property", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const AddPropertiesPage()),
                  );
                }),

            _buildMenuItem(Icons.language, "Latest Lead", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const LatestLeadsPage()),
              );
            }),

            _buildMenuItem(Icons.location_on_outlined,
                "My Listing", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const MyListingsPage()),
                  );
                }),

            _buildMenuItem(
                Icons.account_balance_wallet_outlined,
                "Wallet Balance", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const WalletPage()));
            }),

            _buildMenuItem(Icons.lock_outline,
                "Change password", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ChangePasswordPage()),
                  );
                }),

            _buildMenuItem(Icons.subscriptions_outlined,
                "Subscription",onTap: () {
                  Get.snackbar(
                    "Subscription",
                    " function is coming soon",

                    backgroundColor: AppColors.primaryOrange,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                  );
                }),


            _buildMenuItem(Icons.manage_accounts_outlined,
                "Lead Management",onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const MyListingsPage()),
                  );
                }),

            const Divider(height: 30),

            _buildMenuItem(Icons.delete_outline,
                "Delete Account",
                textColor: Colors.red),


            _buildMenuItem(Icons.logout, "Log Out",
                textColor: Colors.red,
              onTap: () {
                final controller = Get.find<AuthController>();
                controller.logout();
              },),

            const SizedBox(height: 40),

            const Text(
              "App version 003",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon,
      String title, {
        Color textColor = AppColors.primaryBlue,
        VoidCallback? onTap,
      }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primaryBlue,
        ),
        onTap: onTap,
      ),
    );
  }
}
