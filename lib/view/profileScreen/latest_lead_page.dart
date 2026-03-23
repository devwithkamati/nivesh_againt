import 'package:flutter/material.dart';

import '../../controller/ledd_controller.dart';
import '../../model/lead_model.dart';

class LatestLeadsPage extends StatefulWidget {
  const LatestLeadsPage({super.key});

  @override
  State<LatestLeadsPage> createState() => _LatestLeadsPageState();
}

class _LatestLeadsPageState extends State<LatestLeadsPage> {
  static const Color primaryBlue = Color(0xFF2F6FD6);
  static const Color lightGrey = Color(0xFFF2F4F7);

  final controller = LeadController();

  @override
  void initState() {
    super.initState();
    controller.fetchLeads("9876543210"); // 🔥 dynamic mobile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title:
            const Text("Latest Leads", style: TextStyle(color: Colors.white)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: const [
          Icon(Icons.filter_list, color: Colors.white),
          SizedBox(width: 15),
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          // FILTER SAME
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  _tab("All Leads", true),
                  _tab("New", false),
                  _tab("In Progress", false),
                  _tab("Site Visit", false),
                  _tab("Closed", false),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ✅ DYNAMIC LIST
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.isNotEmpty) {
                  return Center(child: Text(controller.error));
                }

                if (controller.leads.isEmpty) {
                  return const Center(child: Text("No Leads Found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.leads.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        LeadCard(lead: controller.leads[index]),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryBlue,
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Add New Lead"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
  final LeadModel lead;

  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TOP =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://niveshcore.com/${lead.propertyImage}",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                        "assets/images/homeimg.png",
                        height: 80,
                        width: 80),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 NAME
                      Text(
                        lead.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lead.propertyLocation,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // 🔥 PRICE
                      Text(
                        "₹ ${lead.propertyPrice.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lead.status, // 🔥 dynamic status
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            // ================= CONTACT =================
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lead.name),
                    Text(lead.mobile,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                Text(
                  lead.createdDate.substring(0, 10), // simple date
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= REQUIREMENT =================
            Row(
              children: const [
                Icon(Icons.article_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text("Requirement  •  ", style: TextStyle(color: Colors.grey)),
                Text("Buy", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                const Text("Budget: ", style: TextStyle(color: Colors.grey)),
                Text(
                  "₹ ${lead.userBudget.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ================= BUTTONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
