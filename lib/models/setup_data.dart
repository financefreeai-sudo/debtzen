import 'package:flutter/foundation.dart';

class SetupData extends ChangeNotifier {
  // ───────── SECTION 1 : PROFILE ─────────
  String name = '';
  DateTime? dob;
  String city = '';
  String maritalStatus = 'Single';
  int dependents = 0;

  // SECTION 2 — INCOME
  double monthlySalary = 0;

  bool get isProfileValid => dob != null && city.isNotEmpty;

  void notify() => notifyListeners();
}
