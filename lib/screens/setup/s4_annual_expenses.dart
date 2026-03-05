import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';
import '../../theme.dart';

class S4AnnualExpenses extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S4AnnualExpenses({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<S4AnnualExpenses> createState() => _S4AnnualExpensesState();
}

class _S4AnnualExpensesState extends State<S4AnnualExpenses> {
  final _insuranceCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _travelCtrl = TextEditingController();
  final _festivalCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = context.read<SetupData>();

    if (data.insurancePremium != null) {
      _insuranceCtrl.text = data.insurancePremium!.toString();
    }

    if (data.schoolFees != null) {
      _schoolCtrl.text = data.schoolFees!.toString();
    }

    if (data.travel != null) {
      _travelCtrl.text = data.travel!.toString();
    }

    if (data.festival != null) {
      _festivalCtrl.text = data.festival!.toString();
    }

    if (data.vehicleService != null) {
      _vehicleCtrl.text = data.vehicleService!.toString();
    }

    if (data.otherAnnual != null) {
      _otherCtrl.text = data.otherAnnual!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return Column(
          children: [
            /// ==============================
            /// SCROLLABLE CONTENT
            /// ==============================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                          Text("Annual Expenses", style: AppTheme.heading(16)),
                          const SizedBox(height: 4),

                          const Text(
                            "Enter yearly amounts — we'll divide by 12 automatically",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _row(
                            "🛡️",
                            "Insurance Premium (optional)",
                            _insuranceCtrl,
                            (v) {
                              data.insurancePremium = v.isEmpty
                                  ? null
                                  : _parse(v);
                              data.notify();
                            },
                          ),

                          _row("🎓", "School Fees (optional)", _schoolCtrl, (
                            v,
                          ) {
                            data.schoolFees = v.isEmpty ? null : _parse(v);
                            data.notify();
                          }),

                          _row("✈️", "Travel", _travelCtrl, (v) {
                            data.travel = v.isEmpty ? null : _parse(v);
                            data.notify();
                          }),

                          _row("🎉", "Festival", _festivalCtrl, (v) {
                            data.festival = v.isEmpty ? null : _parse(v);
                            data.notify();
                          }),

                          _row("🔧", "Vehicle Service", _vehicleCtrl, (v) {
                            data.vehicleService = v.isEmpty ? null : _parse(v);
                            data.notify();
                          }),

                          _row("📦", "Other Annual (optional)", _otherCtrl, (
                            v,
                          ) {
                            data.otherAnnual = v.isEmpty ? null : _parse(v);
                            data.notify();
                          }),

                          const SizedBox(height: 16),

                          /// MONTHLY EQUIVALENT
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
                                  "Monthly Equivalent",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.muted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "₹ ${data.monthlyEquivalentFromAnnual.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ==============================
            /// FIXED BOTTOM BUTTON BAR
            /// ==============================
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
                      onPressed: data.isAnnualExpensesValid
                          ? widget.onNext
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.isAnnualExpensesValid
                            ? const Color(0xFF0B2A3C)
                            : const Color(0xFFD9D9D9),
                        foregroundColor: data.isAnnualExpensesValid
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
            ),
          ],
        );
      },
    );
  }

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
