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
    num readNum(String key, [String? alt]) {
      final primary = num.tryParse('${json[key] ?? ''}');
      if (primary != null) return primary;
      if (alt != null) return num.tryParse('${json[alt] ?? ''}') ?? 0;
      return 0;
    }

    int readInt(String key, [String? alt]) {
      return readNum(key, alt).toInt();
    }

    return DashboardSummaryModel(
      totalCurrentBalance: readNum('total_current_balance', 'balance'),
      totalDebtGiven: readNum('total_debt_given', 'total_debt'),
      totalPaymentReceived: readNum('total_payment_received', 'total_payment'),
      customersCount: readInt('customers_count', 'total_customers'),
      activeCustomersCount: readInt('active_customers_count', 'active_customers'),
      pendingApprovalsCount: readInt('pending_approvals_count', 'pending_approvals'),
      todayDebtGiven: readNum('today_debt_given', 'debt_given_today'),
      todayPaymentReceived: readNum('today_payment_received', 'payment_received_today'),
    );
  }
}
