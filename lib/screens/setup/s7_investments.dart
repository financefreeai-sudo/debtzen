import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S7Investments extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S7Investments({super.key, required this.onNext, required this.onBack});

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
                      "Investments",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Add your current investments (optional)",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    if (data.investments.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "No investments added.\nTap below to add one.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    ...data.investments.map((inv) => _InvestmentCard(inv)),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: () => data.addInvestment(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "+ Add Investment",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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
                  /// Total Investments
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
                          "Total Investments",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹ ${data.totalInvestments.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Skip (subtle)
                  TextButton(
                    onPressed: onNext,
                    child: const Text(
                      "Skip this section",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Back + Next Row
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

/// ============================================================
/// INVESTMENT CARD
/// ============================================================

class _InvestmentCard extends StatelessWidget {
  final Investment investment;

  const _InvestmentCard(this.investment);

  @override
  Widget build(BuildContext context) {
    final data = context.read<SetupData>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: investment.type,
            decoration: const InputDecoration(labelText: "Investment Type"),
            items: data.investmentTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              investment.type = value!;
              data.notify();
            },
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: investment.currentValue?.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Current Value",
                    prefixText: "₹ ",
                  ),
                  onChanged: (v) {
                    investment.currentValue = double.tryParse(v);
                    data.notify();
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: TextFormField(
                  initialValue: investment.monthlyContribution?.toStringAsFixed(
                    0,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Monthly SIP",
                    prefixText: "₹ ",
                  ),
                  onChanged: (v) {
                    investment.monthlyContribution = double.tryParse(v);
                    data.notify();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextFormField(
            initialValue: investment.expectedReturn?.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Expected Return % (optional)",
            ),
            onChanged: (v) {
              investment.expectedReturn = double.tryParse(v);
              data.notify();
            },
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => data.removeInvestment(investment),
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
