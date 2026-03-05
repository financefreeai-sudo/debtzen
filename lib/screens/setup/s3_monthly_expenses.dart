import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';
import '../../theme.dart';

class S3MonthlyExpenses extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S3MonthlyExpenses({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<S3MonthlyExpenses> createState() => _S3MonthlyExpensesState();
}

class _S3MonthlyExpensesState extends State<S3MonthlyExpenses> {
  final _rentCtrl = TextEditingController();
  final _foodCtrl = TextEditingController();
  final _electricCtrl = TextEditingController();
  final _internetCtrl = TextEditingController();
  final _transportCtrl = TextEditingController();
  final _medicalCtrl = TextEditingController();
  final _entertainCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = context.read<SetupData>();

    if (data.houseRent != null) _rentCtrl.text = data.houseRent!.toString();
    if (data.foodGroceries != null)
      _foodCtrl.text = data.foodGroceries!.toString();
    if (data.electricityBills != null)
      _electricCtrl.text = data.electricityBills!.toString();
    if (data.internetMobile != null)
      _internetCtrl.text = data.internetMobile!.toString();
    if (data.transport != null)
      _transportCtrl.text = data.transport!.toString();
    if (data.medicalExpenses != null)
      _medicalCtrl.text = data.medicalExpenses!.toString();
    if (data.entertainment != null)
      _entertainCtrl.text = data.entertainment!.toString();
    if (data.otherMonthlyExpenses != null)
      _otherCtrl.text = data.otherMonthlyExpenses!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// MAIN CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Monthly Expenses", style: AppTheme.heading(16)),
                    const SizedBox(height: 4),
                    const Text(
                      "Regular monthly spending",
                      style: TextStyle(fontSize: 12, color: AppTheme.muted),
                    ),

                    const SizedBox(height: 16),

                    _row("🏠", "House Rent (optional)", _rentCtrl, (v) {
                      data.houseRent = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("🛒", "Food & Groceries", _foodCtrl, (v) {
                      data.foodGroceries = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("⚡", "Electricity & Bills (optional)", _electricCtrl, (
                      v,
                    ) {
                      data.electricityBills = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("📶", "Internet & Mobile", _internetCtrl, (v) {
                      data.internetMobile = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("🚗", "Transport", _transportCtrl, (v) {
                      data.transport = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("💊", "Medical (optional)", _medicalCtrl, (v) {
                      data.medicalExpenses = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("🎬", "Entertainment", _entertainCtrl, (v) {
                      data.entertainment = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    _row("📦", "Other (optional)", _otherCtrl, (v) {
                      data.otherMonthlyExpenses = v.isEmpty ? null : _parse(v);
                      data.notify();
                    }),

                    const SizedBox(height: 14),

                    /// TOTAL ROW
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Monthly Expenses",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "₹ ${data.totalMonthlyExpenses.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// NAV BUTTONS
              Row(
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
                      onPressed: data.isExpensesValid ? widget.onNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.isExpensesValid
                            ? const Color(0xFF0B2A3C)
                            : const Color(0xFFD9D9D9),
                        foregroundColor: data.isExpensesValid
                            ? Colors.white
                            : Colors.grey,
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
        );
      },
    );
  }

  /// Row Widget with Premium Optional Styling
  Widget _row(
    String emoji,
    String label,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    final isOptional = label.contains("(optional)");
    final mainText = label.replaceAll(" (optional)", "");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: TextSpan(
                text: mainText,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w600,
                ),
                children: isOptional
                    ? const [
                        TextSpan(
                          text: " (optional)",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
          ),

          Container(
            width: 110,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChanged,
              decoration: const InputDecoration(
                prefixText: "₹ ",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _parse(String value) => double.tryParse(value) ?? 0;
}
