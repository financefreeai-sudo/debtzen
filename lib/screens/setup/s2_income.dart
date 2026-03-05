import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S2Income extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S2Income({super.key, required this.onNext, required this.onBack});

  @override
  State<S2Income> createState() => _S2IncomeState();
}

class _S2IncomeState extends State<S2Income> {
  bool showSecondIncome = false;

  final amount1Ctrl = TextEditingController();
  final amount2Ctrl = TextEditingController();
  final bonusCtrl = TextEditingController();

  final List<String> incomeTypes = ["Salary", "Business", "Freelance", "Other"];

  @override
  void initState() {
    super.initState();

    final data = context.read<SetupData>();

    amount1Ctrl.text = data.incomeSource1Amount == 0
        ? ""
        : data.incomeSource1Amount.toString();

    amount2Ctrl.text = data.incomeSource2Amount == 0
        ? ""
        : data.incomeSource2Amount.toString();

    bonusCtrl.text = data.annualBonus == 0 ? "" : data.annualBonus.toString();

    if (data.incomeSource2Amount > 0 || data.incomeSource2Type.isNotEmpty) {
      showSecondIncome = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SetupData>();

    double totalMonthly =
        data.incomeSource1Amount +
        data.incomeSource2Amount +
        (data.annualBonus / 12);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Income Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// INCOME SOURCE 1
                const Text(
                  "INCOME SOURCE 1",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: data.incomeSource1Type,
                  decoration: _inputDecoration(),
                  items: incomeTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    data.incomeSource1Type = v!;
                    data.notify();
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: amount1Ctrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(prefix: "₹ "),
                  onChanged: (v) {
                    data.incomeSource1Amount =
                        double.tryParse(v.replaceAll(",", "")) ?? 0;
                    data.notify();
                  },
                ),

                const SizedBox(height: 20),

                /// ADD SECOND SOURCE
                if (!showSecondIncome)
                  GestureDetector(
                    onTap: () => setState(() => showSecondIncome = true),
                    child: const Text(
                      "+ Add another income source",
                      style: TextStyle(
                        color: Color(0xFF0B2A3C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (showSecondIncome) ...[
                  const Text(
                    "INCOME SOURCE 2",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: data.incomeSource2Type.isEmpty
                        ? incomeTypes.first
                        : data.incomeSource2Type,
                    decoration: _inputDecoration(),
                    items: incomeTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      data.incomeSource2Type = v!;
                      data.notify();
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: amount2Ctrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(prefix: "₹ "),
                    onChanged: (v) {
                      data.incomeSource2Amount =
                          double.tryParse(v.replaceAll(",", "")) ?? 0;
                      data.notify();
                    },
                  ),

                  const SizedBox(height: 20),
                ],

                /// BONUS
                const Text(
                  "ANNUAL BONUS (OPTIONAL)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: bonusCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(prefix: "₹ "),
                  onChanged: (v) {
                    data.annualBonus =
                        double.tryParse(v.replaceAll(",", "")) ?? 0;
                    data.notify();
                  },
                ),

                const SizedBox(height: 20),

                /// TOTAL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Monthly Income",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "₹${totalMonthly.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// NAV BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  child: const Text("← Back"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: data.incomeSource1Amount > 0
                      ? widget.onNext
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: data.incomeSource1Amount > 0
                        ? const Color(0xFF0B2A3C)
                        : const Color(0xFFD9D9D9),
                    foregroundColor: data.incomeSource1Amount > 0
                        ? Colors.white
                        : Colors.grey.shade600,
                    elevation: data.incomeSource1Amount > 0 ? 4 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: const Size.fromHeight(55),
                  ),
                  child: const Text(
                    "Next →",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? prefix}) {
    return InputDecoration(
      prefixText: prefix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
