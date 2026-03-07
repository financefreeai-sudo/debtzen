import '../models/setup_data.dart';

class Alert {
  final String title;
  final String message;
  final String level;

  Alert({required this.title, required this.message, required this.level});
}

class AlertEngine {
  final SetupData setup;

  AlertEngine(this.setup);

  List<Alert> generateAlerts() {
    List<Alert> alerts = [];

    double income = setup.totalMonthlyIncome;
    double expenses = setup.finalMonthlyExpense;
    double emi = setup.totalMonthlyEmi;

    double moneyLeft = income - expenses - emi;

    /// DEFICIT ALERT
    if (moneyLeft < 0) {
      alerts.add(
        Alert(
          title: "Deficit Alert",
          message:
              "Overspending by ₹${moneyLeft.abs().toStringAsFixed(0)} this month",
          level: "critical",
        ),
      );
    }

    /// EMI BURDEN ALERT
    if (setup.emiBurdenPercent > 50) {
      alerts.add(
        Alert(
          title: "Danger Zone",
          message:
              "EMI is ${setup.emiBurdenPercent.toStringAsFixed(0)}% of income",
          level: "danger",
        ),
      );
    }

    /// EMERGENCY FUND ALERT
    if (setup.emergencyMonthsCovered < 1) {
      alerts.add(
        Alert(
          title: "Emergency Fund Risk",
          message: "You have less than 1 month emergency fund",
          level: "warning",
        ),
      );
    }

    /// LOW SAVINGS ALERT
    if (setup.savingsRate < 10) {
      alerts.add(
        Alert(
          title: "Low Savings Rate",
          message: "Savings rate is below 10%",
          level: "warning",
        ),
      );
    }

    return alerts;
  }
}
