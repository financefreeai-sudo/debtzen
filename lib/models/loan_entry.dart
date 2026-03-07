class LoanEntry {
  String id;
  String name;
  double principal;
  double interestRate;
  int months;
  double emi;

  LoanEntry({
    required this.id,
    required this.name,
    required this.principal,
    required this.interestRate,
    required this.months,
    required this.emi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'principal': principal,
      'interestRate': interestRate,
      'months': months,
      'emi': emi,
    };
  }

  factory LoanEntry.fromMap(Map<String, dynamic> map) {
    return LoanEntry(
      id: map['id'],
      name: map['name'],
      principal: (map['principal'] ?? 0).toDouble(),
      interestRate: (map['interestRate'] ?? 0).toDouble(),
      months: map['months'] ?? 0,
      emi: (map['emi'] ?? 0).toDouble(),
    );
  }
}
