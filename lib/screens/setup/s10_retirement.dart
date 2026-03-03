import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/setup_data.dart';

class S10Retirement extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const S10Retirement({super.key, required this.onNext, required this.onBack});

  @override
  State<S10Retirement> createState() => _S10RetirementState();
}

class _S10RetirementState extends State<S10Retirement> {
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = context.read<SetupData>();
    _ageController.text = data.targetRetirementAge.toString();
  }

  int _calculateCurrentAge(DateTime? dob) {
    if (dob == null) return 30;
    return DateTime.now().difference(dob).inDays ~/ 365;
  }

  int _yearsToGo(SetupData data) {
    final currentAge = _calculateCurrentAge(data.dob);
    return (data.targetRetirementAge - currentAge).clamp(1, 50);
  }

  double _requiredSip(SetupData data) {
    final years = _yearsToGo(data);
    final months = years * 12;
    if (months == 0) return 0;
    return data.freedomNumber / months;
  }

  String _formatCrore(double value) {
    return (value / 10000000).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupData>(
      builder: (context, data, _) {
        final yearsToGo = _yearsToGo(data);
        final sip = _requiredSip(data);

        return Column(
          children: [
            /// ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Retirement Plan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Last section — almost done!",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "TARGET RETIREMENT AGE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// AGE INPUT BOX
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF0B2A3C),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF0B2A3C)),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                              onChanged: (v) {
                                final age = int.tryParse(v);
                                if (age != null && age >= 35 && age <= 75) {
                                  data.targetRetirementAge = age;
                                  data.notify();
                                }
                              },
                            ),
                          ),
                          const Text(
                            "years old",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Type any age between 35 and 75 — we'll calculate your Freedom Number instantly",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// FREEDOM NUMBER CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F1E3),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE0C98F)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "FREEDOM NUMBER PREVIEW",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "₹ ${_formatCrore(data.freedomNumber)} Crore",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB68D2C),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Based on your data • 6% inflation",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Required SIP",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${sip.toStringAsFixed(0)}/mo",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Years to go",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "$yearsToGo years",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// ================= BOTTOM BUTTONS =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
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
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Complete Setup →",
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
