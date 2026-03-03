import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S9Insurance extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S9Insurance({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        return Column(
          children: [
            /// ================= SCROLLABLE =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Insurance Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Protection for you and family",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    /// ================= HEALTH =================
                    const Text(
                      "HEALTH INSURANCE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _StyledInput(
                      label: "Health Coverage",
                      initialValue: data.healthCoverage > 0
                          ? data.healthCoverage.toStringAsFixed(0)
                          : "",
                      onChanged: (v) {
                        data.healthCoverage = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 16),

                    _StyledInput(
                      label: "Annual Premium",
                      initialValue: data.healthPremiumAnnual > 0
                          ? data.healthPremiumAnnual.toStringAsFixed(0)
                          : "",
                      onChanged: (v) {
                        data.healthPremiumAnnual = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 20),

                    /// ================= PEOPLE COVERED =================
                    const Text(
                      "PEOPLE COVERED",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [1, 2, 3, 4]
                          .map(
                            (num) => _PeopleChip(
                              value: num,
                              selected: data.healthPeopleCovered == num,
                              onTap: () {
                                data.healthPeopleCovered = num;
                                data.notify();
                              },
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 30),

                    /// ================= TERM =================
                    const Text(
                      "TERM INSURANCE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _StyledInput(
                      label: "Term Coverage",
                      initialValue: data.termCoverage > 0
                          ? data.termCoverage.toStringAsFixed(0)
                          : "",
                      onChanged: (v) {
                        data.termCoverage = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 16),

                    _StyledInput(
                      label: "Annual Premium",
                      initialValue: data.termPremiumAnnual > 0
                          ? data.termPremiumAnnual.toStringAsFixed(0)
                          : "",
                      onChanged: (v) {
                        data.termPremiumAnnual = double.tryParse(v) ?? 0;
                        data.notify();
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// ================= BOTTOM BUTTONS =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("← Back"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onNext,
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
                        style: TextStyle(fontWeight: FontWeight.w600),
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
}

/// ================= STYLED INPUT =================
class _StyledInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;

  const _StyledInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixText: "₹ ",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

/// ================= PEOPLE CHIP =================
class _PeopleChip extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _PeopleChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? const Color(0xFF0B2A3C) : Colors.grey.shade200,
        ),
        child: Text(
          value == 4 ? "4+" : value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
