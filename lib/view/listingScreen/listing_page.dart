import 'package:dtbroker_agent/utils/app_colors.dart';
import 'package:dtbroker_agent/view/homeScreen/dashboard_page.dart';
import 'package:dtbroker_agent/view/profileScreen/add_properties_page.dart';
import 'package:flutter/material.dart';

class  ListingPage extends StatefulWidget {
  const  ListingPage({super.key});

  @override
  State< ListingPage> createState() =>  ListingPageState();
}

class  ListingPageState extends State< ListingPage> {
  int selectedTab = 0; // 0 = Active, 1 = Draft

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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= TABS =================
            Container(
              height: 50,
              color: AppColors.background,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = 0);
                    },
                    child: Text(
                      "Active (18)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedTab == 0
                            ? const Color(0xFF0D47A1) // Blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = 1);
                    },
                    child: Text(
                      "Draft (05)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedTab == 1
                            ? const Color(0xFF0D47A1)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ================= ADD PROPERTY BUTTON =================
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8F00), // Orange
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPropertiesPage()));
                },
                icon: const Icon(Icons.add_home, color: Colors.white),
                label: const Text("Add Property",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= LIST CARDS =================
            _listingCard(
              image: "assets/images/homeimg.png",
              title: "3 BHK Apartment for Sale",
              location: "Sector 74, Noida",
              price: "₹ 78 Lac",
              time: "1 day ago",
              leads: "3 Leads",
              views: "218 Views",
            ),

            const SizedBox(height: 10),

            _listingCard(
              image: "assets/images/Buyingimage.png",
              title: "House for Rent",
              location: "Andheri East, Mumbai",
              price: "₹ 45,000 / month",
              time: "3 days ago",
              leads: "5 Leads",
              views: "245 Views",
            ),

            const SizedBox(height: 10),

            _listingCard(
              image: "assets/images/homeimg.png",
              title: "House for Rent",
              location: "Andheri East, Mumbai",
              price: "₹ 45,000 / month",
              time: "3 days ago",
              leads: "5 Leads",
              views: "245 Views",
            ),

            const SizedBox(height: 10),

            _listingCard(
              image: "assets/images/Buyingimage.png",
              title: "House for Rent",
              location: "Andheri East, Mumbai",
              price: "₹ 45,000 / month",
              time: "3 days ago",
              leads: "5 Leads",
              views: "245 Views",
            ),
          ],
        ),
      ),
    );
  }

  /// ================= LISTING CARD =================
  Widget _listingCard({
    required String image,
    required String title,
    required String location,
    required String price,
    required String time,
    required String leads,
    required String views,
  }) {
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            /// TOP ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(location,
                                style: const TextStyle(
                                    color: Colors.grey)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(price,
                          style: const TextStyle(
                              color: Color(0xFF0D47A1), // Blue
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(time,
                              style: const TextStyle(
                                  color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// BOTTOM BUTTON ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomButton(Icons.people, leads),
                _bottomButton(Icons.remove_red_eye, views),
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
            Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
