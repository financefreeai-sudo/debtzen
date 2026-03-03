import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/setup_data.dart';

import 'setup/s1_profile.dart';
import 'setup/s2_income.dart';
import 'setup/s3_monthly_expenses.dart';
import 'setup/s4_annual_expenses.dart';
import 'setup/s5_loans.dart';
import 'setup/s6_bank_savings.dart';
import 'setup/s7_investments.dart';
import 'setup/s8_assets.dart';
import 'setup/s9_insurance.dart';
import 'setup/s10_retirement.dart';
import 'setup/s11_setup_complete.dart';

class QuickSetupScreen extends StatefulWidget {
  final String userName;

  const QuickSetupScreen({super.key, required this.userName});

  @override
  State<QuickSetupScreen> createState() => _QuickSetupScreenState();
}

class _QuickSetupScreenState extends State<QuickSetupScreen> {
  late final PageController _pageController;
  late final SetupData _setupData; // 👈 STORE PROVIDER HERE

  int currentPage = 0;
  final int totalPages = 10;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupData = SetupData(); // 👈 CREATE INSTANCE MANUALLY
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() => currentPage++);
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: _setupData, // 👈 PASS SAME INSTANCE
            child: S11SetupComplete(
              onDashboard: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      );
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _setupData, // 👈 USE STORED INSTANCE
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E9EF),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2B46),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quick Setup",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "5 min",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "10 sections to build your complete financial picture",
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        S1Profile(onNext: nextPage),
                        S2Income(onNext: nextPage, onBack: prevPage),
                        S3MonthlyExpenses(onNext: nextPage, onBack: prevPage),
                        S4AnnualExpenses(onNext: nextPage, onBack: prevPage),
                        S5Loans(onNext: nextPage, onBack: prevPage),
                        S6BankSavings(onNext: nextPage, onBack: prevPage),
                        S7Investments(onNext: nextPage, onBack: prevPage),
                        S8Assets(onNext: nextPage, onBack: prevPage),
                        S9Insurance(onNext: nextPage, onBack: prevPage),
                        S10Retirement(onNext: nextPage, onBack: prevPage),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
