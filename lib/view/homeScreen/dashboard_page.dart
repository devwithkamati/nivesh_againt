import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../listingScreen/listing_page.dart';
import '../profileScreen/profile_page.dart';
import 'home_page.dart';
 // 👈 Import this

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  var selectedIndex = 0;

  List pages = [
    HomePage(),
    ListingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        // ✅ Brand Colors Applied
        backgroundColor: AppColors.primaryBlue,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: Colors.white,

        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Listing'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
