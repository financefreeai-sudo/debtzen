import '../models/setup_data.dart';

class FinancialEngine {
  final SetupData setup;

  FinancialEngine(this.setup);

  /// ================= MONEY LEFT =================

  double get moneyLeftThisMonth {
    return setup.totalMonthlyIncome -
        setup.finalMonthlyExpense -
        setup.totalMonthlyEmi;
  }

  /// ================= SAVINGS RATE =================

  double get savingsRate {
    if (setup.totalMonthlyIncome == 0) return 0;

    final savings =
        setup.totalMonthlyIncome -
        setup.finalMonthlyExpense -
        setup.totalMonthlyEmi;

    return (savings / setup.totalMonthlyIncome) * 100;
  }

  /// ================= EMI BURDEN =================

  double get emiBurdenPercent {
    if (setup.totalMonthlyIncome == 0) return 0;

    return (setup.totalMonthlyEmi / setup.totalMonthlyIncome) * 100;
  }

  /// ================= EMERGENCY FUND =================

  double get emergencyMonths {
    if (setup.emergencyFund == null || setup.finalMonthlyExpense == 0) {
      return 0;
    }

    return setup.emergencyFund! / setup.finalMonthlyExpense;
  }

  /// ================= NET WORTH =================

  double get netWorth {
    return setup.netWorth;
  }

  /// ================= RISK LEVEL =================

  String get riskLevel {
    if (emiBurdenPercent > 50 || emergencyMonths < 1) {
      return "High Risk";
    }

    if (emiBurdenPercent > 30 || emergencyMonths < 3) {
      return "Moderate Risk";
    }

    return "Low Risk";
  }

  /// ================= FINANCIAL SCORE =================

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

    if (emergencyMonths >= 6) {
      score += 20;
    } else if (emergencyMonths >= 3) {
      score += 10;
    }

    if (score < 0) return 0;
    if (score > 100) return 100;

    return score;
  }
}
