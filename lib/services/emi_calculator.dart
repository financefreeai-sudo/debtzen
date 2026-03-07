import 'dart:math';

double calculateEMI({
  required double principal,
  required double annualRate,
  required int months,
}) {
  double r = annualRate / 12 / 100;

  double emi = principal * r * (pow(1 + r, months)) / (pow(1 + r, months) - 1);

  return emi;
}
