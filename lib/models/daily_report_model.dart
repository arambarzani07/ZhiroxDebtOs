class DailyReportModel {
  const DailyReportModel({
    required this.date,
    required this.totalCurrentBalance,
    required this.totalDebtGiven,
    required this.totalPaymentReceived,
    required this.activeCustomersCount,
    required this.receiptsCount,
  });

  final String date;
  final num totalCurrentBalance;
  final num totalDebtGiven;
  final num totalPaymentReceived;
  final int activeCustomersCount;
  final int receiptsCount;

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    final report = json['report'] is Map ? Map<String, dynamic>.from(json['report']) : json;

    num readNum(String key, [String? alt]) {
      final primary = num.tryParse('${report[key] ?? ''}');
      if (primary != null) return primary;
      if (alt != null) return num.tryParse('${report[alt] ?? ''}') ?? 0;
      return 0;
    }

    int readInt(String key, [String? alt]) {
      return readNum(key, alt).toInt();
    }

    return DailyReportModel(
      date: '${json['date'] ?? report['date'] ?? ''}',
      totalCurrentBalance: readNum('total_current_balance', 'balance'),
      totalDebtGiven: readNum('total_debt_given', 'total_debt'),
      totalPaymentReceived: readNum('total_payment_received', 'total_payment'),
      activeCustomersCount: readInt('active_customers_count', 'active_customers'),
      receiptsCount: readInt('receipts_count', 'receipt_count'),
    );
  }
}
