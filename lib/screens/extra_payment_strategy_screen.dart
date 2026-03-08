import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';

class ExtraPaymentStrategyScreen extends StatefulWidget {
  const ExtraPaymentStrategyScreen({super.key});

  @override
  State<ExtraPaymentStrategyScreen> createState() =>
      _ExtraPaymentStrategyScreenState();
}

class _ExtraPaymentStrategyScreenState
    extends State<ExtraPaymentStrategyScreen> {
  double extraEmi = 0;

  int? monthsSaved;
  double? interestSaved;

  String? currentDebtFreeDate;
  String? newDebtFreeDate;

  int selectedLoanIndex = 0;

  int? selectedLoanMonthsSaved;
  bool showHelperTip = false;

  /// SIMULATION ENGINE
  Map<String, dynamic> runSimulation(
    List<_SimLoan> loans,
    double extra,
    int targetLoan,
  ) {
    int months = 0;
    double totalInterest = 0;

    while (loans.any((l) => l.balance > 0)) {
      months++;

      for (int i = 0; i < loans.length; i++) {
        final loan = loans[i];

        if (loan.balance <= 0) continue;

        double monthlyRate = loan.rate / 12 / 100;

        double interest = loan.balance * monthlyRate;

        loan.balance += interest;

        totalInterest += interest;

        double payment = loan.emi;

        if (i == targetLoan) {
          payment += extra;
        }

        loan.balance -= payment;

        if (loan.balance < 0) {
          loan.balance = 0;
        }
      }
    }

    return {"months": months, "interest": totalInterest};
  }

  void simulate(SetupData setup) {
    if (setup.loans.isEmpty) return;

    /// Calculate remaining months per loan
    List<int> remainingMonths = setup.loans.map((l) {
      int tenure = l.tenureMonths ?? 0;
      int paid = l.emiPaidMonths ?? 0;
      return tenure - paid;
    }).toList();

    int longestLoanMonths = remainingMonths.reduce((a, b) => a > b ? a : b);

    int selectedLoanMonths = remainingMonths[selectedLoanIndex];

    showHelperTip = selectedLoanMonths < longestLoanMonths;

    /// BASELINE SIM
    List<_SimLoan> baseLoans = setup.loans.map((l) {
      return _SimLoan(
        balance: l.remainingBalance ?? l.totalAmount ?? 0,
        rate: l.interestRate ?? 0,
        emi: l.monthlyEmi ?? 0,
      );
    }).toList();

    /// EXTRA SIM
    List<_SimLoan> extraLoans = setup.loans.map((l) {
      return _SimLoan(
        balance: l.remainingBalance ?? l.totalAmount ?? 0,
        rate: l.interestRate ?? 0,
        emi: l.monthlyEmi ?? 0,
      );
    }).toList();

    final base = runSimulation(baseLoans, 0, selectedLoanIndex);
    final extra = runSimulation(extraLoans, extraEmi, selectedLoanIndex);

    int baselineMonths = base["months"];
    int newMonths = extra["months"];

    double baselineInterest = base["interest"];
    double newInterest = extra["interest"];

    DateTime now = DateTime.now();

    DateTime currentDate = now.add(Duration(days: baselineMonths * 30));
    DateTime newDate = now.add(Duration(days: newMonths * 30));

    const monthsList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    String format(DateTime d) => "${monthsList[d.month - 1]} ${d.year}";

    setState(() {
      monthsSaved = (baselineMonths - newMonths).abs();
      interestSaved = baselineInterest - newInterest;

      currentDebtFreeDate = format(currentDate);
      newDebtFreeDate = format(newDate);

      selectedLoanMonthsSaved = selectedLoanMonths - newMonths;
      if (selectedLoanMonthsSaved! < 0) {
        selectedLoanMonthsSaved = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final setup = Provider.of<SetupData>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Extra Payment Strategy"),
        backgroundColor: const Color(0xFF163C65),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CURRENT EMI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Monthly EMI",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${setup.totalMonthlyEmi.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// LOAN SELECTOR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonFormField<int>(
                value: selectedLoanIndex,
                decoration: const InputDecoration(
                  labelText: "Apply Extra EMI To",
                  border: OutlineInputBorder(),
                ),
                items: List.generate(setup.loans.length, (index) {
                  final loan = setup.loans[index];
                  return DropdownMenuItem(value: index, child: Text(loan.type));
                }),
                onChanged: (value) {
                  setState(() {
                    selectedLoanIndex = value ?? 0;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            /// EXTRA EMI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "Extra EMI per Month",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹${extraEmi.toStringAsFixed(0)} extra EMI",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Slider(
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    value: extraEmi,
                    onChanged: (value) {
                      setState(() {
                        extraEmi = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF163C65),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => simulate(setup),
                    child: const Text("Calculate Strategy"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// RESULT
            if (monthsSaved != null)
              Container(
                width: double.infinity,
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

                    if (currentDebtFreeDate != null)
                      Text("Current Debt Free: $currentDebtFreeDate"),

                    const SizedBox(height: 4),

                    if (newDebtFreeDate != null)
                      Text("With Extra EMI: $newDebtFreeDate"),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.trending_down, size: 18),
                        const SizedBox(width: 6),
                        Text("Debt Free Faster By: $monthsSaved months"),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (selectedLoanMonthsSaved != null &&
                        selectedLoanMonthsSaved! > 0)
                      Text(
                        "${setup.loans[selectedLoanIndex].type} closes $selectedLoanMonthsSaved months earlier",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.savings, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Interest Saved: ₹${interestSaved!.toStringAsFixed(0)}",
                        ),
                      ],
                    ),

                    if (showHelperTip) ...[
                      const SizedBox(height: 10),
                      const Text(
                        "💡 Tip: Extra EMI works best on long or high-interest loans.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SimLoan {
  double balance;
  double rate;
  double emi;

  _SimLoan({required this.balance, required this.rate, required this.emi});
}
