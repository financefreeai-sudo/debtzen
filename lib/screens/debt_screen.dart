import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';
import 'add_loan_screen.dart';
import 'loan_simulation_hub_screen.dart'; // ⭐ NEW IMPORT

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final setup = Provider.of<SetupData>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF163C65),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddLoanScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B2A4A), Color(0xFF163C65)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Loans",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TOP CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _topCard(
                          "MONTHLY EMI",
                          "₹${setup.totalMonthlyEmi.toStringAsFixed(0)}",
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _topCard(
                          "TOTAL DEBT",
                          "₹${setup.totalLoanAmount.toStringAsFixed(0)}",
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _topCard("DEBT FREE", setup.debtFreeDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// EMI HEALTH
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "EMI Health",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "EMI is ${setup.emiBurdenPercent.toStringAsFixed(0)}% of income",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _emiHealthText(setup),
                            style: TextStyle(
                              color: _emiHealthColor(setup),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Loans",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// LOAN LIST
                    Expanded(
                      child: setup.loans.isEmpty
                          ? const Center(child: Text("No loans added yet"))
                          : ListView.builder(
                              itemCount: setup.loans.length,
                              itemBuilder: (context, index) {
                                final loan = setup.loans[index];

                                final monthsLeft =
                                    (loan.tenureMonths ?? 0) -
                                    (loan.emiPaidMonths ?? 0);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      /// ICON
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          _loanIcon(loan.type),
                                          size: 22,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      /// LOAN INFO
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              loan.type,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              "${loan.interestRate ?? 0}% · $monthsLeft months left",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            /// PROGRESS BAR
                                            LinearProgressIndicator(
                                              value: _loanProgress(loan),
                                              minHeight: 6,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              color: const Color(0xFF163C65),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      /// EMI + ACTIONS
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${(loan.monthlyEmi ?? 0).toStringAsFixed(0)} / month",
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AddLoanScreen(
                                                            loan: loan,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),

                                              const SizedBox(width: 10),

                                              GestureDetector(
                                                onTap: () {
                                                  setup.removeLoan(loan);
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 10),

                    /// SIMULATE BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoanSimulationHubScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF163C65)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart),
                            SizedBox(width: 10),
                            Text(
                              "Simulate New Loan Impact",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TOP CARD
  Widget _topCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4F73),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// LOAN PROGRESS
  double _loanProgress(Loan loan) {
    final paid = loan.emiPaidMonths ?? 0;
    final total = loan.tenureMonths ?? 1;

    return (paid / total).clamp(0, 1);
  }

  /// SMART LOAN ICON
  IconData _loanIcon(String type) {
    final name = type.toLowerCase();

    if (name.contains("home")) return Icons.home;
    if (name.contains("car")) return Icons.directions_car;
    if (name.contains("credit")) return Icons.credit_card;
    if (name.contains("education")) return Icons.school;
    if (name.contains("gold")) return Icons.workspace_premium;

    return Icons.account_balance;
  }

  /// EMI HEALTH TEXT
  String _emiHealthText(SetupData setup) {
    final percent = setup.emiBurdenPercent;

    if (percent < 30) return "Safe EMI level";
    if (percent < 50) return "Warning: EMI getting high";
    return "Risk: EMI too high";
  }

  /// EMI HEALTH COLOR
  Color _emiHealthColor(SetupData setup) {
    final percent = setup.emiBurdenPercent;

    if (percent < 30) return Colors.green;
    if (percent < 50) return Colors.orange;
    return Colors.red;
  }
}
