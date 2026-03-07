import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Updated

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1), // Updated
        title: const Text("Wallet",
            style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme:
        const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [

          const SizedBox(height: 40),

          // ================= BALANCE CARD =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0D47A1), // Blue
                      Color(0xFF1E88E5), // Light Blue
                    ],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Current Wallet Balance",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "₹7,560",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Available: ₹7,560 | Pending ₹840",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ================= WITHDRAW SECTION =================
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Withdrawable Amount"),
                        Text(
                          "₹7,560.00",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFFFF8F00), // Orange
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                8),
                          ),
                        ),
                        onPressed: () {},
                        child:
                        const Text("Withdraw",
                            style: TextStyle(
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ================= TABS =================
          TabBar(
            controller: _tabController,
            labelColor:
            const Color(0xFF0D47A1), // Blue
            unselectedLabelColor: Colors.grey,
            indicatorColor:
            const Color(0xFF0D47A1), // Blue
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Credits"),
              Tab(text: "Debits"),
            ],
          ),

          // ================= TRANSACTION LIST =================
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _transactionList(),
                _transactionList(isCredit: true),
                _transactionList(isCredit: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionList({bool? isCredit}) {

    final transactions = [
      {
        "title": "Referral Reward",
        "subtitle": "Reward for new referral",
        "amount": "+ ₹500.00",
        "credit": true,
        "time": "Today, 11:30 AM"
      },
      {
        "title": "Property Sale Commission",
        "subtitle": "Sold house in Mumbai",
        "amount": "+ ₹3,000.00",
        "credit": true,
        "time": "Yesterday, 5:45 PM"
      },
      {
        "title": "Money Withdrawal",
        "subtitle": "Transferred to bank",
        "amount": "- ₹5,000.00",
        "credit": false,
        "time": "Apr 21, 2:00 PM"
      },
    ];

    final filtered = isCredit == null
        ? transactions
        : transactions
        .where((e) => e["credit"] == isCredit)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {

        final item = filtered[index];
        final isPositive = item["credit"] as bool;

        return Card(
          margin:
          const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isPositive
                  ? const Color(0xFF1E88E5)
                  .withOpacity(0.15)
                  : const Color(0xFFFF8F00)
                  .withOpacity(0.15),
              child: Icon(
                isPositive
                    ? Icons.currency_rupee
                    : Icons.money_off,
                color: isPositive
                    ? const Color(0xFF0D47A1)
                    : const Color(0xFFFF8F00),
              ),
            ),
            title: Text(
              item["title"].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(item["subtitle"].toString()),
                const SizedBox(height: 4),
                Text(
                  item["time"].toString(),
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ],
            ),
            trailing: Text(
              item["amount"].toString(),
              style: TextStyle(
                color: isPositive
                    ? const Color(0xFF0D47A1)
                    : const Color(0xFFFF8F00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
