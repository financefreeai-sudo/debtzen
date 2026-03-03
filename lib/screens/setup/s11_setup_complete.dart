import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S11SetupComplete extends StatelessWidget {
  final VoidCallback onDashboard;

  const S11SetupComplete({super.key, required this.onDashboard});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F2B46),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// ✅ Success Icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1EC15F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Setup Complete!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Your financial picture is ready",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  /// ================= SUMMARY CARD =================
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3B5A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _summaryRow(
                          "Monthly Income",
                          "₹ ${data.totalMonthlyIncome.toStringAsFixed(0)}",
                          Colors.green,
                        ),
                        _summaryRow(
                          "Total EMI",
                          "₹ ${data.totalMonthlyEmi.toStringAsFixed(0)}",
                          Colors.red,
                        ),
                        _summaryRow(
                          "Total Expenses",
                          "₹ ${data.finalMonthlyExpense.toStringAsFixed(0)}",
                          Colors.orange,
                        ),
                        _summaryRow(
                          "Monthly Savings",
                          "₹ ${data.finalNetBalance.toStringAsFixed(0)}",
                          Colors.green,
                        ),
                        _summaryRow(
                          "Net Worth",
                          "₹ ${data.netWorth.toStringAsFixed(0)}",
                          Colors.amber,
                        ),
                        _summaryRow(
                          "Debt Ratio",
                          "${data.emiBurdenPercent.toStringAsFixed(1)}%",
                          Colors.orange,
                        ),
                        _summaryRow(
                          "Freedom Number",
                          "₹ ${(data.freedomNumber / 10000000).toStringAsFixed(2)} Cr",
                          Colors.amber,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= FINANCIAL SCORE CARD =================
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        /// 🔥 Dynamic Circular Score
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: data.financialScore / 100,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _scoreColor(data.financialScore),
                                ),
                              ),
                              Text(
                                data.financialScore.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B2A3C),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Financial Health Score",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Good — EMI is in safe zone",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// ================= CTA BUTTON =================
                  ElevatedButton(
                    onPressed: onDashboard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "View Your Dashboard →",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 Dynamic Score Color Logic
  Color _scoreColor(int score) {
    if (score <= 40) {
      return Colors.red;
    } else if (score <= 70) {
      return Colors.orange;
    } else {
      return const Color(0xFF1EC15F);
    }
  }

  /// Summary Row Widget
  Widget _summaryRow(String title, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}
