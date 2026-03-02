import 'package:flutter/material.dart';
import '../theme.dart';

class QuickSetupScreen extends StatelessWidget {
  const QuickSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        title: const Text('Quick Setup', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Quick Setup — Feature 3', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
