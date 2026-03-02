import 'package:flutter/material.dart';
import '../theme.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Dashboard — Feature 4', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
