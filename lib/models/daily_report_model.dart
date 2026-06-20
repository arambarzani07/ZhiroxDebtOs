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
    final report = json['report'] is Map ? Map<String, dynamic>.from(json['report']) : <String, dynamic>{};
    num readNum(String key) => num.tryParse('${report[key] ?? 0}') ?? 0;
    int readInt(String key) => int.tryParse('${report[key] ?? 0}') ?? 0;
    return DailyReportModel(
      date: '${json['date'] ?? ''}',
      totalCurrentBalance: readNum('total_current_balance'),
      totalDebtGiven: readNum('total_debt_given'),
      totalPaymentReceived: readNum('total_payment_received'),
      activeCustomersCount: readInt('active_customers_count'),
      receiptsCount: readInt('receipts_count'),
    );
  }
}
