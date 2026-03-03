import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S8Assets extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S8Assets({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return Column(
          children: [
            /// ================= SCROLLABLE AREA =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Assets",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Add your physical assets (optional)",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// Gold
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Gold Value",
                        prefixText: "₹ ",
                      ),
                      onChanged: (v) {
                        data.goldValue = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 14),

                    /// Property
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Property Value (Home / Flat)",
                        prefixText: "₹ ",
                      ),
                      onChanged: (v) {
                        data.propertyValue = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 14),

                    /// Land
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Land Value (Optional)",
                        prefixText: "₹ ",
                      ),
                      onChanged: (v) {
                        data.landValue = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 14),

                    /// Vehicle
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Vehicle Value (Optional)",
                        prefixText: "₹ ",
                      ),
                      onChanged: (v) {
                        data.vehicleValue = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// ================= FIXED BOTTOM AREA =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  /// Total Physical Assets
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Physical Assets",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹ ${data.totalPhysicalAssets.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Skip (same style as S7)
                  TextButton(
                    onPressed: onNext,
                    child: const Text(
                      "Skip this section",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Back + Next Row (IDENTICAL TO S7)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onBack,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text("← Back"),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B2A3C),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Next →",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
