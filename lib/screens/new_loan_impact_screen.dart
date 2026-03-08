import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';

class NewLoanImpactScreen extends StatefulWidget {
  const NewLoanImpactScreen({super.key});

  @override
  State<NewLoanImpactScreen> createState() => _NewLoanImpactScreenState();
}

class _NewLoanImpactScreenState extends State<NewLoanImpactScreen> {
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _tenureController = TextEditingController();

  double? newEmi;
  double? newEmiPercent;
  String? riskLevel;
  int? delayMonths;

  /// EMI CALCULATION
  double calculateEmi(double principal, double annualRate, int months) {
    double r = annualRate / 12 / 100;

    double emi =
        principal * r * (pow(1 + r, months)) / (pow(1 + r, months) - 1);

    return emi;
  }

  void simulate() {
    final setup = Provider.of<SetupData>(context, listen: false);

    double amount = double.tryParse(_amountController.text) ?? 0;
    double rate = double.tryParse(_rateController.text) ?? 0;
    int tenure = int.tryParse(_tenureController.text) ?? 0;

    /// INPUT VALIDATION
    if (amount <= 0 || rate <= 0 || tenure <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid loan details")),
      );
      return;
    }

    double emi = calculateEmi(amount, rate, tenure);

    double totalEmi = setup.totalMonthlyEmi + emi;

    double percent = 0;

    /// VALIDATION: Income must exist
    if (setup.totalMonthlyIncome <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add income in setup first")),
      );
      return;
    }

    percent = (totalEmi / setup.totalMonthlyIncome) * 100;

    String risk;

    if (percent < 30) {
      risk = "Safe EMI level";
    } else if (percent < 50) {
      risk = "Warning: EMI getting high";
    } else {
      risk = "Risk: EMI too high";
    }

    /// BETTER DEBT DELAY CALCULATION
    int currentMaxMonths = 0;

    for (var loan in setup.loans) {
      int remaining = (loan.tenureMonths ?? 0) - (loan.emiPaidMonths ?? 0);

      if (remaining > currentMaxMonths) {
        currentMaxMonths = remaining;
      }
    }

    int addedMonths = max(0, tenure - currentMaxMonths);

    setState(() {
      newEmi = emi;
      newEmiPercent = percent;
      riskLevel = risk;
      delayMonths = addedMonths;
    });
  }

  /// MEMORY SAFETY
  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setup = Provider.of<SetupData>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        title: const Text("New Loan Impact"),
        backgroundColor: const Color(0xFF163C65),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// CURRENT EMI CARD
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
                    "Current EMI",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${setup.totalMonthlyEmi.toStringAsFixed(0)} / month",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// LOAN AMOUNT
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Loan Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            /// INTEREST RATE
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Interest Rate (%)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            /// TENURE
            TextField(
              controller: _tenureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Tenure (Months)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// CALCULATE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF163C65),
                foregroundColor: Colors.white, // FIX
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: simulate,
              child: const Text("Calculate Impact"),
            ),

            const SizedBox(height: 20),

            /// RESULT CARD
            if (newEmi != null)
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
                      "Simulation Result",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "New Loan EMI: ₹${newEmi!.toStringAsFixed(0)} / month",
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Total EMI After Loan: ₹${(setup.totalMonthlyEmi + newEmi!).toStringAsFixed(0)}",
                    ),

                    const SizedBox(height: 6),

                    Text("EMI Burden: ${newEmiPercent!.toStringAsFixed(1)}%"),

                    const SizedBox(height: 6),

                    if (delayMonths != null)
                      Text(
                        "Debt Free Delay: $delayMonths months",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                    const SizedBox(height: 6),

                    Text(
                      "Risk Level: $riskLevel",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
