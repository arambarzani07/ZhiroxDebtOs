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
    String readText(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = '${json[key] ?? ''}'.trim();
        if (value.isNotEmpty && value != 'null') return value;
      }
      return fallback;
    }

    int readInt(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is int) return value;
        if (value is num) return value.toInt();
        final parsed = num.tryParse('${value ?? ''}');
        if (parsed != null) return parsed.toInt();
      }
      return 0;
    }

    return CustomerModel(
      id: readInt(['id', 'customer_id', 'customers_id']),
      fullName: readText(['full_name', 'name', 'customer_name', 'display_name']),
      phone: readText(['phone', 'mobile', 'phone_number']),
      address: readText(['address', 'location']),
      status: readText(['status'], fallback: 'active'),
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
    num readNum(List<String> keys) {
      for (final key in keys) {
        final value = num.tryParse('${json[key] ?? ''}');
        if (value != null) return value;
      }
      return 0;
    }

    String readText(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = '${json[key] ?? ''}'.trim();
        if (value.isNotEmpty && value != 'null') return value;
      }
      return fallback;
    }

    return CustomerProfileModel(
      currentBalance: readNum(['current_balance', 'balance', 'remaining_balance']),
      totalDebtGiven: readNum(['total_debt_given', 'debt_given', 'total_debt']),
      totalPaymentReceived: readNum(['total_payment_received', 'payment_received', 'total_payment']),
      creditLimit: readNum(['credit_limit', 'limit']),
      trustScore: readNum(['trust_score', 'trust_points']),
      riskLevel: readText(['risk_level', 'risk'], fallback: 'low'),
      debtHealth: readText(['debt_health', 'health'], fallback: 'healthy'),
    );
  }
}
