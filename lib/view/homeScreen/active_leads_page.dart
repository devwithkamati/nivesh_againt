import 'package:flutter/material.dart';

class ActiveLeadsPage extends StatelessWidget {
  static const Color primaryColor = Color(0xFF2D5016);
  static const Color accentColor = Color(0xFFE6C56F);
  static const Color backgroundColor = Color(0xFFF8FAF5);
  const ActiveLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: backgroundColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('Active Leads', style: TextStyle(color: backgroundColor)),
      ),
    );
  }
}
