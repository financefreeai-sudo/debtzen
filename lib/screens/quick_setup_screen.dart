import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late final SetupData _setupData;

  int currentPage = 0;
  final int totalPages = 10;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _setupData = SetupData();

    /// LOAD SAVED DATA FIRST
    loadInitialData();

    /// LIVE AUTO SAVE LISTENER
    _setupData.addListener(autoSave);
  }

  /// LOAD STEP + DATA IN ORDER
  Future<void> loadInitialData() async {
    await loadSetupData();
    await loadSavedStep();
  }

  /// AUTO SAVE WHENEVER DATA CHANGES
  void autoSave() {
    saveSetupData();
  }

  /// LOAD LAST SAVED STEP
  Future<void> loadSavedStep() async {
    final prefs = await SharedPreferences.getInstance();
    int savedStep = prefs.getInt("setup_step") ?? 0;

    setState(() {
      currentPage = savedStep;
    });

    _pageController.jumpToPage(savedStep);
  }

  /// SAVE CURRENT STEP
  Future<void> saveStep() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("setup_step", currentPage);
  }

  /// SAVE SETUP DATA
  Future<void> saveSetupData() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(_setupData.toJson());

    await prefs.setString("setup_data", jsonString);
  }

  /// LOAD SETUP DATA
  Future<void> loadSetupData() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString("setup_data");

    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      _setupData.fromJson(jsonData);
    }
  }

  void nextPage() async {
    if (currentPage < totalPages - 1) {
      HapticFeedback.lightImpact();

      setState(() => currentPage++);

      await saveStep();
      await saveSetupData();

      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("setup_step");
      prefs.remove("setup_data");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: _setupData,
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

  void prevPage() async {
    if (currentPage > 0) {
      setState(() => currentPage--);

      await saveStep();
      await saveSetupData();

      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildProgressSteps() {
    return Row(
      children: List.generate(totalPages, (index) {
        bool completed = index < currentPage;
        bool active = index == currentPage;

        Color circleColor;
        Widget child;

        if (completed) {
          circleColor = Colors.green;
          child = const Icon(Icons.check, size: 14, color: Colors.white);
        } else if (active) {
          circleColor = const Color(0xFFFFC542);
          child = Text(
            "${index + 1}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          circleColor = Colors.white24;
          child = const SizedBox();
        }

        return Expanded(
          child: Row(
            children: [
              AnimatedScale(
                scale: active ? 1.15 : 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
              if (index != totalPages - 1)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: 3,
                    color: index < currentPage ? Colors.green : Colors.white24,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    /// REMOVE LISTENER
    _setupData.removeListener(autoSave);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _setupData,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Quick Setup",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "10 sections to build your complete financial picture",
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 18),
                      buildProgressSteps(),
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
