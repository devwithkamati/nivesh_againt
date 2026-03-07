import 'package:dtbroker_agent/controller/admin_profile_controller.dart';
import 'package:dtbroker_agent/view/profileScreen/add_properties_page.dart';
import 'package:dtbroker_agent/view/profileScreen/latest_lead_page.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';

import 'notification_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final profileController = Get.find<AdminProfileController>();
  int selectedTab = 0;
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.lightBlue,
                ],
              ),
            ),
            child: Obx(() {

              final data = profileController.profile.value;

              if (profileController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Row(
                children: [

                  /// 🔹 Profile Image
                  Obx(() {
                    final data = profileController.profile.value;

                    return CircleAvatar(
                      radius: 28,
                      backgroundImage: data?.agentImage != null &&
                          data!.agentImage!.isNotEmpty
                          ? NetworkImage(
                          "https://niveshcore.com${data.agentImage}?t=${DateTime.now().millisecondsSinceEpoch}")
                          : const AssetImage(
                          "assets/images/profile_image.jpeg") as ImageProvider,
                    );
                  }),

                  const SizedBox(width: 12),

                  /// 🔹 Name & Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "${getGreeting()}  ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          data?.agentName ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                       ),
                      ],
                    ),
                  ),

                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotificationPage(
                                notifications:notificationList,
                              ),
                            ),
                          );
                        },
                      ),
                      if (notificationList.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notificationList.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              );
            }),
          ),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _statsSection(),
            const SizedBox(height: 20),
            _buttonsSection( context),
            const SizedBox(height: 25),
            _leadsOverviewSection(),
            const SizedBox(height: 25),
            _recentActivitiesSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ================= LEADS OVERVIEW =================
  Widget _leadsOverviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 0),
                    child: Text(
                      "Leads Overview",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: selectedTab == 0
                            ? AppColors.primaryBlue
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 1),
                    child: Text(
                      "Recent Activity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: selectedTab == 1
                            ? AppColors.primaryBlue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              selectedTab == 0
                  ? Column(
                children: const [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _OverviewBox(Icons.person, "12", "New Leads"),
                      _OverviewBox(Icons.access_time, "5", "In Progress"),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _OverviewBox(Icons.location_on, "3", "Site Visits"),
                      _OverviewBox(Icons.check_circle, "3", "Closed Leads"),
                    ],
                  ),
                ],
              )
                  : Column(
                children: [
                  _simpleActivityTile(
                      "Property Viewed", "2 hours ago"),
                  const SizedBox(height: 10),
                  _simpleActivityTile(
                      "New Lead Added", "5 hours ago"),
                  const SizedBox(height: 10),
                  _simpleActivityTile(
                      "Site Visit Scheduled", "Yesterday"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleActivityTile(String title, String time) {
    return Row(
      children: [
        const Icon(Icons.circle,
            size: 8, color: AppColors.primaryOrange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

/// ================= STATS =================
Widget _statsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _StatItem(Icons.person, "268", "Total Leads"),
            _StatItem(Icons.home, "34", "Total Listings"),
            _StatItem(Icons.apartment, "17", "Active Listings"),
            _StatItem(Icons.remove_red_eye, "428", "Today's Views"),
          ],
        ),
      ),
    ),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const _StatItem(this.icon, this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.circle, size: 0), // placeholder fix
        Icon(icon, color: AppColors.primaryBlue),
        const SizedBox(height: 4),
        Text(number,
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

/// ================= BUTTONS =================
Widget _buttonsSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(
          child: _actionButton(
            Icons.add,
            "Add Property",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const AddPropertiesPage(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _actionButton(
            Icons.person_add,
            "Add Lead",
                () {
              // TODO: Add Lead Page navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const LatestLeadsPage(),
                    ),
                  );
            },
          ),
        ),
      ],
    ),
  );
}


Widget _actionButton(
    IconData icon,
    String text,
    VoidCallback onTap,
    ) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.lightBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}


/// ================= RECENT ACTIVITIES =================
Widget _recentActivitiesSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activities",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(width: 220, child: _rentActivityCard()),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _rentActivityCard() {
  return Card(
    shape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/homeimg.png",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "House for Rent in Noida, UP\n2 days ago",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "₹ 45,000 / month",
            style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class _OverviewBox extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const _OverviewBox(this.icon, this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(height: 6),
          Text(number,
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }
}
