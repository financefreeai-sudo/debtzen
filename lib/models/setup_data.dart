import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================
/// LOAN MODEL
/// ============================================================

class Loan {
  String type;
  double? totalAmount;
  double? monthlyEmi;
  double? interestRate;
  int? tenureMonths;

  /// NEW: remaining balance for accurate net worth
  double? remainingBalance;

  Loan({
    this.type = "Home Loan",
    this.totalAmount,
    this.monthlyEmi,
    this.interestRate,
    this.tenureMonths,
    this.remainingBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "totalAmount": totalAmount,
      "monthlyEmi": monthlyEmi,
      "interestRate": interestRate,
      "tenureMonths": tenureMonths,
      "remainingBalance": remainingBalance,
    };
  }

  static Loan fromJson(Map<String, dynamic> json) {
    return Loan(
      type: json["type"] ?? "Home Loan",
      totalAmount: (json["totalAmount"])?.toDouble(),
      monthlyEmi: (json["monthlyEmi"])?.toDouble(),
      interestRate: (json["interestRate"])?.toDouble(),
      tenureMonths: json["tenureMonths"],
      remainingBalance: (json["remainingBalance"])?.toDouble(),
    );
  }
}

/// ============================================================
/// INVESTMENT MODEL
/// ============================================================

class Investment {
  String type;
  double? currentValue;
  double? monthlyContribution;
  double? expectedReturn;

  Investment({
    this.type = "Mutual Fund",
    this.currentValue,
    this.monthlyContribution,
    this.expectedReturn,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "currentValue": currentValue,
      "monthlyContribution": monthlyContribution,
      "expectedReturn": expectedReturn,
    };
  }

  static Investment fromJson(Map<String, dynamic> json) {
    return Investment(
      type: json["type"] ?? "Mutual Fund",
      currentValue: (json["currentValue"])?.toDouble(),
      monthlyContribution: (json["monthlyContribution"])?.toDouble(),
      expectedReturn: (json["expectedReturn"])?.toDouble(),
    );
  }
}

/// ============================================================
/// SETUP DATA MASTER ENGINE
/// ============================================================

class SetupData extends ChangeNotifier {
  /// ================= PROFILE =================

  String name = '';
  DateTime? dob;
  String city = '';
  String maritalStatus = 'Single';
  int dependents = 0;

  bool get isProfileValid => dob != null && name.isNotEmpty;

  int get currentAge {
    if (dob == null) return 30;
    return DateTime.now().difference(dob!).inDays ~/ 365;
  }

  /// ================= INCOME =================

  String incomeSource1Type = "Salary";
  double incomeSource1Amount = 0;

  String incomeSource2Type = "";
  double incomeSource2Amount = 0;

  double annualBonus = 0;

  double get totalMonthlyIncome =>
      incomeSource1Amount + incomeSource2Amount + (annualBonus / 12);

  bool get isIncomeValid => incomeSource1Amount > 0;

  /// ================= MONTHLY EXPENSES =================

  double? houseRent;
  double? electricityBills;
  double? medicalExpenses;
  double? otherMonthlyExpenses;

  double? foodGroceries;
  double? internetMobile;
  double? transport;
  double? entertainment;

  double get totalMonthlyExpenses =>
      (houseRent ?? 0) +
      (foodGroceries ?? 0) +
      (electricityBills ?? 0) +
      (internetMobile ?? 0) +
      (transport ?? 0) +
      (medicalExpenses ?? 0) +
      (entertainment ?? 0) +
      (otherMonthlyExpenses ?? 0);

  bool get isExpensesValid =>
      foodGroceries != null &&
      internetMobile != null &&
      transport != null &&
      entertainment != null;

  /// ================= ANNUAL EXPENSES =================

  double? insurancePremium;
  double? schoolFees;
  double? otherAnnual;
  double? travel;
  double? festival;
  double? vehicleService;

  double get totalAnnualExpenses =>
      (insurancePremium ?? 0) +
      (schoolFees ?? 0) +
      (travel ?? 0) +
      (festival ?? 0) +
      (vehicleService ?? 0) +
      (otherAnnual ?? 0);

  double get monthlyEquivalentFromAnnual => totalAnnualExpenses / 12;

  bool get isAnnualExpensesValid =>
      travel != null && festival != null && vehicleService != null;

  /// ================= LOANS =================

  List<Loan> loans = [];

  final List<String> loanTypes = [
    "Home Loan",
    "Personal Loan",
    "Car Loan",
    "Education Loan",
    "Gold Loan",
    "Credit Card",
    "Buy Now Pay Later",
    "Other",
  ];

  double get totalMonthlyEmi =>
      loans.fold(0, (sum, loan) => sum + (loan.monthlyEmi ?? 0));

  double get totalLoanAmount => loans.fold(
    0,
    (sum, loan) => sum + (loan.remainingBalance ?? loan.totalAmount ?? 0),
  );

  void addLoan() {
    loans.add(Loan());
    notify();
  }

  void removeLoan(Loan loan) {
    loans.remove(loan);
    notify();
  }

  /// ================= BANK =================

  double? bankBalance;
  double? emergencyFund;

  bool get isSavingsValid => bankBalance != null;

  /// ================= INVESTMENTS =================

  List<Investment> investments = [];

  final List<String> investmentTypes = [
    "Mutual Fund",
    "Stocks",
    "Fixed Deposit",
    "PPF / EPF",
    "Gold",
    "Real Estate",
    "Crypto",
    "Other",
  ];

  void addInvestment() {
    investments.add(Investment());
    notify();
  }

  void removeInvestment(Investment inv) {
    investments.remove(inv);
    notify();
  }

  double get totalInvestments =>
      investments.fold(0, (sum, inv) => sum + (inv.currentValue ?? 0));

  double get totalMonthlyInvestment =>
      investments.fold(0, (sum, inv) => sum + (inv.monthlyContribution ?? 0));

  /// ================= PHYSICAL ASSETS =================

  double goldValue = 0;
  double propertyValue = 0;
  double landValue = 0;
  double vehicleValue = 0;

  double get totalPhysicalAssets =>
      goldValue + propertyValue + landValue + vehicleValue;

  /// ================= INSURANCE =================

  double healthCoverage = 0;
  double healthPremiumAnnual = 0;
  int healthPeopleCovered = 1;

  double termCoverage = 0;
  double termPremiumAnnual = 0;

  double get totalMonthlyInsurancePremium =>
      (healthPremiumAnnual + termPremiumAnnual) / 12;

  /// ================= RETIREMENT =================

  int targetRetirementAge = 50;

  int get yearsToRetirement => (targetRetirementAge - currentAge).clamp(1, 50);

  double get finalMonthlyExpense =>
      totalMonthlyExpenses + monthlyEquivalentFromAnnual;

  static const double inflationRate = 0.06;

  double get futureMonthlyExpense =>
      finalMonthlyExpense * pow((1 + inflationRate), yearsToRetirement);

  double get freedomNumber {
    final yearlyExpense = futureMonthlyExpense * 12;
    return yearlyExpense * 25;
  }

  /// expected investment return (12% yearly)
  static const double investmentReturn = 0.12;

  double get requiredSip {
    final months = yearsToRetirement * 12;
    if (months <= 0) return 0;

    final r = investmentReturn / 12;
    final fv = freedomNumber;

    final sip = fv * r / (pow(1 + r, months) - 1);

    return sip;
  }

  /// ================= NET WORTH =================

  double get totalAssets =>
      (bankBalance ?? 0) + totalInvestments + totalPhysicalAssets;

  double get netWorth => totalAssets - totalLoanAmount;

  double get freedomProgressPercent {
    if (freedomNumber == 0) return 0;

    final progress = (netWorth / freedomNumber) * 100;

    if (progress < 0) return 0;
    if (progress > 100) return 100;

    return progress;
  }

  /// ================= FINANCIAL HEALTH =================

  double get netAfterExpenses => totalMonthlyIncome - finalMonthlyExpense;

  double get finalNetBalance => netAfterExpenses - totalMonthlyEmi;

  double get trueMonthlySavings => finalNetBalance + totalMonthlyInvestment;

  double get savingsRate {
    if (totalMonthlyIncome == 0) return 0;
    return (finalNetBalance / totalMonthlyIncome) * 100;
  }

  double get expenseRatio {
    if (totalMonthlyIncome == 0) return 0;
    return (finalMonthlyExpense / totalMonthlyIncome) * 100;
  }

  double get emiBurdenPercent {
    if (totalMonthlyIncome == 0) return 0;
    return (totalMonthlyEmi / totalMonthlyIncome) * 100;
  }

  double get emergencyMonthsCovered {
    if (finalMonthlyExpense == 0 || emergencyFund == null) return 0;
    return emergencyFund! / finalMonthlyExpense;
  }

  String get riskLevel {
    if (emiBurdenPercent > 50 || emergencyMonthsCovered < 1) {
      return "High Risk";
    } else if (emiBurdenPercent > 30 || emergencyMonthsCovered < 3) {
      return "Moderate Risk";
    } else {
      return "Low Risk";
    }
  }

  int get financialScore {
    int score = 50;

    if (savingsRate > 30) {
      score += 20;
    } else if (savingsRate > 15) {
      score += 10;
    }

    if (emiBurdenPercent > 50) {
      score -= 20;
    } else if (emiBurdenPercent > 35) {
      score -= 10;
    }

    if (emergencyMonthsCovered >= 6) {
      score += 20;
    } else if (emergencyMonthsCovered >= 3) {
      score += 10;
    }

    if (score < 0) return 0;
    if (score > 100) return 100;

    return score;
  }

  /// ================= AUTO SAVE =================

  void notify() {
    saveToLocal();
    notifyListeners();
  }

  /// ================= JSON SUPPORT =================

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "city": city,
      "maritalStatus": maritalStatus,
      "dependents": dependents,
      "dob": dob?.millisecondsSinceEpoch,
      "loans": loans.map((l) => l.toJson()).toList(),
      "investments": investments.map((i) => i.toJson()).toList(),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    name = json["name"] ?? "";
    city = json["city"] ?? "";
    maritalStatus = json["maritalStatus"] ?? "Single";
    dependents = json["dependents"] ?? 0;

    if (json["dob"] != null) {
      dob = DateTime.fromMillisecondsSinceEpoch(json["dob"]);
    }

    loans = (json["loans"] as List? ?? [])
        .map((e) => Loan.fromJson(e))
        .toList();

    investments = (json["investments"] as List? ?? [])
        .map((e) => Investment.fromJson(e))
        .toList();

    notifyListeners();
  }

  /// ================= LOCAL STORAGE =================

  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("setup_data", jsonEncode(toJson()));
  }

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("setup_data");

    if (raw != null) {
      fromJson(jsonDecode(raw));
    }
  }
}
