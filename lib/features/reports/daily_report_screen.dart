import 'package:flutter/material.dart';

import '../../models/daily_report_model.dart';
import '../../widgets/stat_card.dart';

class DailyReportScreen extends StatelessWidget {
  const DailyReportScreen({
    super.key,
    required this.report,
    required this.onRefresh,
  });

  final DailyReportModel report;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕاپۆرتی ڕۆژانە'),
        actions: [
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          StatCard(
            title: 'بەروار',
            value: report.date,
            icon: Icons.calendar_month,
          ),
          StatCard(
            title: 'کۆی Balance',
            value: '${report.totalCurrentBalance} IQD',
            icon: Icons.account_balance_wallet,
          ),
          StatCard(
            title: 'کۆی قەرزدان',
            value: '${report.totalDebtGiven} IQD',
            icon: Icons.trending_up,
          ),
          StatCard(
            title: 'کۆی پارەدانەوە',
            value: '${report.totalPaymentReceived} IQD',
            icon: Icons.payments,
          ),
          StatCard(
            title: 'کڕیارە چالاکەکان',
            value: '${report.activeCustomersCount}',
            icon: Icons.people,
          ),
          StatCard(
            title: 'Receipt',
            value: '${report.receiptsCount}',
            icon: Icons.receipt_long,
          ),
        ],
      ),
    );
  }
}
