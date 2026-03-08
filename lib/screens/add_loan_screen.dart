import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';
import 'dart:math';

class AddLoanScreen extends StatefulWidget {
  final Loan? loan;

  const AddLoanScreen({super.key, this.loan});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final rateController = TextEditingController();
  final tenureController = TextEditingController();
  final paidController = TextEditingController();

  double emi = 0;

  @override
  void initState() {
    super.initState();

    /// PREFILL DATA WHEN EDITING
    if (widget.loan != null) {
      nameController.text = widget.loan!.type;
      amountController.text = (widget.loan!.totalAmount ?? 0).toStringAsFixed(
        0,
      );
      rateController.text = (widget.loan!.interestRate ?? 0).toStringAsFixed(0);
      tenureController.text = (widget.loan!.tenureMonths ?? 0).toString();
      paidController.text = (widget.loan!.emiPaidMonths ?? 0).toString();

      emi = widget.loan!.monthlyEmi ?? 0;
    }
  }

  void calculate() {
    double principal = double.tryParse(amountController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    int months = int.tryParse(tenureController.text) ?? 0;

    double r = rate / 12 / 100;

    double result =
        principal * r * pow(1 + r, months) / (pow(1 + r, months) - 1);

    setState(() {
      emi = result;
    });
  }

  void saveLoan() {
    final setup = Provider.of<SetupData>(context, listen: false);

    final loan = Loan(
      type: nameController.text,
      totalAmount: double.parse(amountController.text),
      interestRate: double.parse(rateController.text),
      tenureMonths: int.parse(tenureController.text),
      emiPaidMonths: int.tryParse(paidController.text) ?? 0,
      monthlyEmi: emi,
      remainingBalance: double.parse(amountController.text),
    );

    /// UPDATE OR ADD
    if (widget.loan != null) {
      final index = setup.loans.indexOf(widget.loan!);
      setup.loans[index] = loan;
    } else {
      setup.loans.add(loan);
    }

    setup.notify();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Loan")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Loan Name"),
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Loan Amount"),
            ),

            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Interest Rate %"),
            ),

            TextField(
              controller: tenureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Tenure (Months)",
              ),
            ),

            /// FIXED FIELD LABEL
            TextField(
              controller: paidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "EMIs Already Paid",
                hintText: "Example: 10 (Months)",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculate,
              child: const Text("Calculate EMI"),
            ),

            const SizedBox(height: 20),

            Text(
              "EMI: ₹${emi.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: emi == 0 ? null : saveLoan,
              child: const Text("Save Loan"),
            ),
          ],
        ),
      ),
    );
  }
}
