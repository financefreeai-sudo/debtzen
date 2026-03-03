import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';
import '../../theme.dart';

class S6BankSavings extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S6BankSavings({super.key, required this.onNext, required this.onBack});

  @override
  State<S6BankSavings> createState() => _S6BankSavingsState();
}

class _S6BankSavingsState extends State<S6BankSavings> {
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
                      "Bank Savings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Your current savings",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// Bank Balance
                    const Text(
                      "BANK BALANCE (TOTAL SAVINGS)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _currencyInput(
                      hint: "Enter total savings",
                      onChanged: (v) {
                        data.bankBalance = _parse(v);
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Emergency Fund
                    const Text(
                      "EMERGENCY FUND AMOUNT (OPTIONAL)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _currencyInput(
                      hint: "Amount kept aside for emergencies",
                      onChanged: (v) {
                        data.emergencyFund = _parse(v);
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "💡 What is Emergency Fund?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Money set aside for unexpected expenses.\n"
                            "Ideal target: 6 months of expenses "
                            "(₹${(data.finalMonthlyExpense * 6).toStringAsFixed(0)} for you).",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ===============================
            /// FIXED BUTTONS
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
                      onPressed: data.isSavingsValid ? widget.onNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.isSavingsValid
                            ? const Color(0xFF0B2A3C)
                            : const Color(0xFFD9D9D9),
                        foregroundColor: data.isSavingsValid
                            ? Colors.white
                            : Colors.grey,
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Next →"),
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

  Widget _currencyInput({
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixText: "₹ ",
        hintText: hint,
        filled: true,
        fillColor: AppTheme.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  double _parse(String value) => double.tryParse(value) ?? 0;
}
