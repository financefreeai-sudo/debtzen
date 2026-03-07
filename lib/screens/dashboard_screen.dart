import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      body: Center(
        child: Text(
          "Home Dashboard (Coming in Feature 6)",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
