import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';
import '../../theme.dart';

class S5Loans extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S5Loans({super.key, required this.onNext, required this.onBack});

  @override
  State<S5Loans> createState() => _S5LoansState();
}

class _S5LoansState extends State<S5Loans> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return Column(
          children: [
            /// ===============================
            /// SCROLLABLE CONTENT
            /// ===============================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Loans & EMIs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Add your active loans (optional)",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// EMPTY STATE
                    if (data.loans.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "No loans added.\nTap below to add one.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    /// LOAN CARDS
                    ...data.loans.map((loan) => _loanCard(data, loan)),

                    const SizedBox(height: 12),

                    /// ADD LOAN BUTTON
                    GestureDetector(
                      onTap: () {
                        data.addLoan();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "+ Add Loan",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TOTAL EMI
                    _totalEmi(data),
                  ],
                ),
              ),
            ),

            /// ===============================
            /// FIXED BOTTOM BUTTONS
            /// ===============================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      child: const Text("← Back"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: widget.onNext,
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
            ),
          ],
        );
      },
    );
  }

  /// ===============================
  /// LOAN CARD
  /// ===============================
  Widget _loanCard(SetupData data, Loan loan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Loan Type Dropdown
          DropdownButtonFormField<String>(
            value: loan.type,
            decoration: const InputDecoration(labelText: "Loan Type"),
            items: data.loanTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              loan.type = value!;
              data.notify();
            },
          ),

          const SizedBox(height: 12),

          /// Row 1
          Row(
            children: [
              Expanded(
                child: _input("Loan Amount", (v) {
                  loan.totalAmount = _parse(v);
                  data.notify();
                }, isCurrency: true),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _input("Monthly EMI", (v) {
                  loan.monthlyEmi = _parse(v);
                  data.notify();
                }, isCurrency: true),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Row 2
          Row(
            children: [
              Expanded(
                child: _input("Interest %", (v) {
                  loan.interestRate = _parse(v);
                  data.notify();
                }, isCurrency: false),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _input("Tenure (Months)", (v) {
                  loan.tenureMonths = int.tryParse(v);
                  data.notify();
                }, isCurrency: false),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                data.removeLoan(loan);
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// INPUT FIELD
  /// ===============================
  Widget _input(
    String label,
    Function(String) onChanged, {
    bool isCurrency = true,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixText: isCurrency ? "₹ " : null,
        filled: true,
        fillColor: AppTheme.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// ===============================
  /// TOTAL EMI WIDGET
  /// ===============================
  Widget _totalEmi(SetupData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Monthly EMI",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "₹ ${data.totalMonthlyEmi.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  double _parse(String value) => double.tryParse(value) ?? 0;
}
