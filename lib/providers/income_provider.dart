import 'package:flutter/material.dart';
import '../models/income_entry.dart';

class IncomeProvider extends ChangeNotifier {
  final List<IncomeEntry> _incomes = [];

  List<IncomeEntry> get incomes => _incomes;

  double get totalMonthlyIncome =>
      _incomes.fold(0, (sum, item) => sum + item.monthlyAmount);

  void addIncome(IncomeEntry income) {
    _incomes.add(income);
    notifyListeners();
  }

  void removeIncome(String id) {
    _incomes.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
