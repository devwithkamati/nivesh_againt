import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LatestLeadsPage extends StatelessWidget {
  const LatestLeadsPage({super.key});

  static const Color primaryBlue = Color(0xFF2F6FD6);
  static const Color lightGrey = Color(0xFFF2F4F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          "Latest Leads",
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),        ),
        actions: const [
          Icon(Icons.filter_list, color: Colors.white),
          SizedBox(width: 15),
          Stack(
            children: [
              Icon(Icons.person, color: Colors.white),

            ],
          ),
          SizedBox(width: 15),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [

          // ================= FILTER TABS =================
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  _tab("All Leads", false),
                  _tab("New (15)", true),
                  _tab("In Progress", false),
                  _tab("Site Visit", false),
                  _tab("Closed", false),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================= LIST =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                LeadCard(),
                SizedBox(height: 12),
                LeadCard(),
                SizedBox(height: 12),
                LeadCard(),
                LeadCard(),
                SizedBox(height: 12),
                LeadCard(),
                SizedBox(height: 12),
                LeadCard(),
              ],
            ),
          )
        ],
      ),

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryBlue,
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Add New Lead"),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? primaryBlue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ================= LEAD CARD =================

class LeadCard extends StatelessWidget {
  const LeadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= TOP ROW =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/homeimg.png",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "House for Rent in Andheri East",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14,
                              color: Colors.grey),
                          SizedBox(width: 4),
                          Text("Andheri East, Mumbai",
                              style: TextStyle(
                                  color: Colors.grey)),
                        ],
                      ),

                      SizedBox(height: 6),

                      Text("₹ 45,000 / month",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("New Lead",
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),

            const Divider(height: 20),

            // ================= CONTACT =================
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  AssetImage("assets/images/profile_image.jpeg"),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text("Pawan Kumar",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.w600)),
                    Text("+91 9876543210",
                        style: TextStyle(
                            color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                const Text("2m ago",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 12),

            // ================= REQUIREMENT SECTION =================
            Row(
              children: const [
                Icon(Icons.article_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text("Requirement  •  ",
                    style: TextStyle(color: Colors.grey)),
                Text("Rent",
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 12),
                Icon(Icons.bed_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("2 BHK",
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: const [
                Icon(Icons.account_balance_wallet_outlined,
                    size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text("Budget: ",
                    style: TextStyle(color: Colors.grey)),
                Text("40k - 50k",
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 15),

            // ================= BUTTONS =================
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(Icons.call, "Call"),
                _actionButton(Icons.message, "Message"),
                _actionButton(Icons.more_horiz, "More"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(text),
          ],
        ),
      ),
    );
  }
}

