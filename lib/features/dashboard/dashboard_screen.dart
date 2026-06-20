import 'package:flutter/material.dart';

import '../../models/dashboard_summary_model.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.summary,
    required this.onRefresh,
  });

  final DashboardSummaryModel summary;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبۆرد'),
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
            title: 'کۆی قەرزی ماوە',
            value: '${summary.totalCurrentBalance} IQD',
            icon: Icons.account_balance_wallet,
          ),
          StatCard(
            title: 'کۆی قەرزدان',
            value: '${summary.totalDebtGiven} IQD',
            icon: Icons.trending_up,
          ),
          StatCard(
            title: 'کۆی پارەدانەوە',
            value: '${summary.totalPaymentReceived} IQD',
            icon: Icons.payments,
          ),
          StatCard(
            title: 'کڕیارە چالاکەکان',
            value: '${summary.activeCustomersCount}',
            icon: Icons.people,
          ),
          StatCard(
            title: 'چاوەڕوانی ڕەزامەندی',
            value: '${summary.pendingApprovalsCount}',
            icon: Icons.verified,
          ),
          StatCard(
            title: 'قەرزی ئەمڕۆ',
            value: '${summary.todayDebtGiven} IQD',
            icon: Icons.today,
          ),
          StatCard(
            title: 'پارەدانی ئەمڕۆ',
            value: '${summary.todayPaymentReceived} IQD',
            icon: Icons.done_all,
          ),
        ],
      ),
    );
  }
}
