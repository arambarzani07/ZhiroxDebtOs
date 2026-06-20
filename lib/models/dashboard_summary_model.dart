class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.totalCurrentBalance,
    required this.totalDebtGiven,
    required this.totalPaymentReceived,
    required this.customersCount,
    required this.activeCustomersCount,
    required this.pendingApprovalsCount,
    required this.todayDebtGiven,
    required this.todayPaymentReceived,
  });

  final num totalCurrentBalance;
  final num totalDebtGiven;
  final num totalPaymentReceived;
  final int customersCount;
  final int activeCustomersCount;
  final int pendingApprovalsCount;
  final num todayDebtGiven;
  final num todayPaymentReceived;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    num readNum(String key) => num.tryParse('${json[key] ?? 0}') ?? 0;
    int readInt(String key) => int.tryParse('${json[key] ?? 0}') ?? 0;
    return DashboardSummaryModel(
      totalCurrentBalance: readNum('total_current_balance'),
      totalDebtGiven: readNum('total_debt_given'),
      totalPaymentReceived: readNum('total_payment_received'),
      customersCount: readInt('customers_count'),
      activeCustomersCount: readInt('active_customers_count'),
      pendingApprovalsCount: readInt('pending_approvals_count'),
      todayDebtGiven: readNum('today_debt_given'),
      todayPaymentReceived: readNum('today_payment_received'),
    );
  }
}
