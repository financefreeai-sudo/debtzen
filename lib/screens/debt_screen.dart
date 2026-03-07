import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';
import 'add_loan_screen.dart';

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final setup = Provider.of<SetupData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Loans")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddLoanScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SUMMARY CARD
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total EMI"),
                        const SizedBox(height: 6),
                        Text(
                          "₹${setup.totalMonthlyEmi.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Debt"),
                        const SizedBox(height: 6),
                        Text(
                          "₹${setup.totalLoanAmount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Loans",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                        return Card(
                          child: ListTile(
                            title: Text(loan.type),

                            subtitle: Text(
                              "EMI: ₹${(loan.monthlyEmi ?? 0).toStringAsFixed(0)}",
                            ),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setup.removeLoan(loan);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
