import 'package:dtbroker_agent/view/profileScreen/add_properties_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../controller/property_controller.dart';
import '../../model/property_model.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => ListingPageState();
}

class ListingPageState extends State<ListingPage> {
  int selectedTab = 0; // 0 = Active, 1 = Draft
  final controller = PropertyController();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadProperties();
  }

  Future<void> loadProperties() async {
    String? phone = await storage.read(key: "phone");

    print("📱 FETCH PHONE: $phone"); // 👈 ADD THIS

    if (phone != null) {
      controller.fetchProperties(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Updated background

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        title: const Text(
          "My Listings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: const [
          Icon(Icons.filter_list, color: Color(0xFFFF8F00)), // Orange
          SizedBox(width: 15),
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 15),
        ],
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= TABS =================
            // Container(
            //   height: 50,
            //   color: AppColors.background,
            //   child: Row(
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           setState(() => selectedTab = 0);
            //         },
            //         child: Text(
            //           "Active (18)",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: selectedTab == 0
            //                 ? const Color(0xFF0D47A1) // Blue
            //                 : Colors.grey,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 20),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() => selectedTab = 1);
            //         },
            //         child: Text(
            //           "Draft (05)",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: selectedTab == 1
            //                 ? const Color(0xFF0D47A1)
            //                 : Colors.grey,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // const SizedBox(height: 10),

            /// ================= ADD PROPERTY BUTTON =================
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8F00), // Orange
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final phone = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddPropertiesPage()),
                  );

                  if (phone == true) {
                    loadProperties(); // 🔥 always storage wala phone use karega
                  }
                },
                icon: const Icon(Icons.add_home, color: Colors.white),
                label: const Text("Add Property",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                // 🔄 LOADING
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ❌ ERROR
                if (controller.error.isNotEmpty) {
                  return Center(child: Text(controller.error));
                }

                // 📭 EMPTY
                if (controller.properties.isEmpty) {
                  return const Center(child: Text("No Properties Found"));
                }

                // ✅ DATA
                return Column(
                  children: controller.properties.map((property) {
                    return Column(
                      children: [
                        _listingCard(property: property),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// ================= LISTING CARD =================
  Widget _listingCard({
    required PropertyModel property,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            /// ================= TOP ROW =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE (API se)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: property.propertyImage != null &&
                          property.propertyImage!.isNotEmpty
                      ? Image.network(
                          "https://niveshcore.com/${property.propertyImage}",
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            "assets/images/homeimg.png",
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "assets/images/homeimg.png",
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                ),

                const SizedBox(width: 12),

                /// DETAILS (API se)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        property.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),

                      const SizedBox(height: 5),

                      /// LOCATION
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      /// PRICE
                      Text(
                        "₹ ${property.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Color(0xFF0D47A1),
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 5),

                      /// TIME
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            property.createdDate.isNotEmpty
                                ? property.createdDate.substring(0, 10)
                                : "N/A",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= BOTTOM =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomButton(Icons.people, "0 Leads"),
                _bottomButton(Icons.remove_red_eye, "0 Views"),
                _bottomButton(Icons.more_horiz, "More"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton(IconData icon, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1).withOpacity(0.08), // Soft blue
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF0D47A1)),
            const SizedBox(width: 5),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
