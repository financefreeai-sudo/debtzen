import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Income Sources")),
      body: const Center(
        child: Text("Income Screen Working", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
