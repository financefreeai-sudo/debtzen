class IncomeEntry {
  String id;
  String name;
  double amount;
  bool isAnnual;

  IncomeEntry({
    required this.id,
    required this.name,
    required this.amount,
    this.isAnnual = false,
  });

  double get monthlyAmount {
    if (isAnnual) {
      return amount / 12;
    }
    return amount;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'amount': amount, 'isAnnual': isAnnual};
  }

  factory IncomeEntry.fromMap(Map<String, dynamic> map) {
    return IncomeEntry(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      isAnnual: map['isAnnual'] ?? false,
    );
  }
}
