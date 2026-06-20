class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.address = '',
    this.status = 'active',
  });

  final int id;
  final String fullName;
  final String phone;
  final String address;
  final String status;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: int.tryParse('${json['id']}') ?? 0,
      fullName: '${json['full_name'] ?? ''}',
      phone: '${json['phone'] ?? ''}',
      address: '${json['address'] ?? ''}',
      status: '${json['status'] ?? 'active'}',
    );
  }
}

class CustomerProfileModel {
  const CustomerProfileModel({
    required this.currentBalance,
    required this.totalDebtGiven,
    required this.totalPaymentReceived,
    required this.creditLimit,
    required this.trustScore,
    required this.riskLevel,
    required this.debtHealth,
  });

  final num currentBalance;
  final num totalDebtGiven;
  final num totalPaymentReceived;
  final num creditLimit;
  final num trustScore;
  final String riskLevel;
  final String debtHealth;

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    num readNum(String key) => num.tryParse('${json[key] ?? 0}') ?? 0;
    return CustomerProfileModel(
      currentBalance: readNum('current_balance'),
      totalDebtGiven: readNum('total_debt_given'),
      totalPaymentReceived: readNum('total_payment_received'),
      creditLimit: readNum('credit_limit'),
      trustScore: readNum('trust_score'),
      riskLevel: '${json['risk_level'] ?? 'low'}',
      debtHealth: '${json['debt_health'] ?? 'healthy'}',
    );
  }
}
