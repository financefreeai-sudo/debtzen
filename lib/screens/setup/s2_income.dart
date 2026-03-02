import 'package:flutter/material.dart';

class S2Income extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S2Income({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onBack, child: const Text("Back")),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: onNext, child: const Text("Next")),
      ],
    );
  }
}
