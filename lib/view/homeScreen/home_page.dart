import 'package:dtbroker_agent/view/homeScreen/commision_page.dart';
import 'package:dtbroker_agent/view/homeScreen/total_balance_page.dart';
import 'package:dtbroker_agent/view/homeScreen/total_listing_page.dart';
import 'package:dtbroker_agent/view/homeScreen/total_sell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../loginScreen/login_page.dart';
import 'active_leads_page.dart';
import 'kyc_status_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  static const Color primaryColor = Color(0xFF2D5016);
  static const Color accentColor = Color(0xFFE6C56F);
  static const Color backgroundColor = Color(0xFFF8FAF5);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isKycOpen = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePage.backgroundColor,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HomePage.primaryColor,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Icon(
              size: 27,
              Icons.notifications,
              color: HomePage.backgroundColor,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _buildHorizontalSection(),
          _buildGridSection(context),
        ],
      ),
    );
  }

  //  Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: HomePage.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// HEADER
          DrawerHeader(
            decoration: const BoxDecoration(color: HomePage.primaryColor),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/profile_image.jpeg",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("admin@gmail.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          _drawerItem(context, Icons.dashboard, "Dashboard"),
          _drawerItem(context, Icons.person, "Profile"),

          /// 🔥 KYC EXPANDABLE
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text("KYC"),
            trailing: Icon(
              _isKycOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onTap: () {
              setState(() {
                _isKycOpen = !_isKycOpen;
              });
            },
          ),

          /// 🔥 DROPDOWN CONTENT
          if (_isKycOpen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Aadhar Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "PAN Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Bank Account Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "IFSC Code",
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HomePage.primaryColor,
                    ),
                    onPressed: () {},
                    child: const Text("Submit"),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

          _drawerItem(context, Icons.list, "Total listing"),
          _drawerItem(context, Icons.sell, "Total sell"),
          _drawerItem(context, Icons.account_balance_wallet, "Wallet balance"),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await _storage.delete(key: "auth_token");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  /// 🔹 Horizontal Scroll Section
  Widget _buildHorizontalSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 180,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          children: [
            _buildPropertyCard("assets/images/Buyingimage.png", "Luxury Villa",
                "Mumbai", "₹2.5 Cr", "For Sale"),
            _buildPropertyCard("assets/images/homeimg.png", "Modern Apartment",
                "Delhi", "₹85 Lakh", "For Rent"),
            _buildPropertyCard("assets/images/testimagelogo.png", "Farm House",
                "Pune", "₹1.2 Cr", "New Launch"),
            _buildPropertyCard("assets/images/Buyingimage.png",
                "Commercial Space", "Bangalore", "₹3 Cr", "Sold"),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(String image, String title, String location,
      String price, String status) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Stack(
            children: [
              Image.asset(image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(location,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(price,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Grid Section (All Clickable)
  Widget _buildGridSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _dashboardCard(
              context,
              "Total Sell",
              Icons.sell,
              const Color(0xFF1E3C72),
              const Color(0xFF2A5298),
              const TotalSellPage(),
            ),
            _dashboardCard(
              context,
              "Total Listing",
              Icons.list_alt,
              const Color(0xFF134E5E),
              const Color(0xFF71B280),
              const TotalListingPage(),
            ),
            _dashboardCard(
              context,
              "Wallet Balance",
              Icons.account_balance_wallet,
              const Color(0xFF42275A),
              const Color(0xFF734B6D),
              const TotalBalancePage(),
            ),
            _dashboardCard(
              context,
              "Active Leads",
              Icons.person_search,
              const Color(0xFF0F2027),
              const Color(0xFF2C5364),
              const ActiveLeadsPage(),
            ),
            _dashboardCard(
              context,
              "KYC Status",
              Icons.verified_user,
              const Color(0xFF355C7D),
              const Color(0xFF6C5B7B),
              const KycStatusPage(),
            ),
            _dashboardCard(
              context,
              "Commission",
              Icons.trending_up,
              const Color(0xFF2C3E50),
              const Color(0xFF4CA1AF),
              const CommisionPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color1,
    Color color2,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
