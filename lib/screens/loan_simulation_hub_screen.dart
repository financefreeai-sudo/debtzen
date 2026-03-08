import 'package:flutter/material.dart';
import 'new_loan_impact_screen.dart';
import 'extra_payment_strategy_screen.dart';

class LoanSimulationHubScreen extends StatelessWidget {
  const LoanSimulationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        title: const Text("Loan Impact Simulator"),
        backgroundColor: const Color(0xFF163C65),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// NEW LOAN IMPACT
            _optionCard(
              context: context,
              icon: Icons.add_circle_outline,
              title: "New Loan Impact",
              description:
                  "See how taking a new loan affects your EMI, debt-free date and financial freedom.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewLoanImpactScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// EXTRA PAYMENT STRATEGY
            _optionCard(
              context: context,
              icon: Icons.trending_down,
              title: "Extra Payment Strategy",
              description:
                  "See how paying extra EMI every month helps you become debt-free faster.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExtraPaymentStrategyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF163C65).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF163C65), size: 28),
            ),

            const SizedBox(width: 14),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
