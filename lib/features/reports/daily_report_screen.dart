import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../models/daily_report_model.dart';
import '../../widgets/stat_card.dart';

class DailyReportScreen extends StatelessWidget {
  const DailyReportScreen({
    super.key,
    required this.report,
    required this.onRefresh,
    this.weekly = const {},
    this.monthly = const {},
    this.topDebtors = const {},
    this.paidUnpaid = const {},
  });

  final DailyReportModel report;
  final VoidCallback onRefresh;
  final Map<String, dynamic> weekly;
  final Map<String, dynamic> monthly;
  final Map<String, dynamic> topDebtors;
  final Map<String, dynamic> paidUnpaid;

  num readNum(Map<String, dynamic> map, String key) {
    final nested = map['report'];
    if (nested is Map && nested[key] != null) return AppFormatters.safeNum(nested[key]);
    return AppFormatters.safeNum(map[key]);
  }

  int readCount(Map<String, dynamic> map, String key) {
    return AppFormatters.safeInt(map[key]);
  }

  int readListCount(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is List) return value.length;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕاپۆرتەکان'),
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
          Text('ڕاپۆرتی ڕۆژانە', style: Theme.of(context).textTheme.titleMedium),
          StatCard(
            title: 'بەروار',
            value: report.date,
            icon: Icons.calendar_month,
          ),
          StatCard(
            title: 'کۆی باڵانس',
            value: AppFormatters.money(report.totalCurrentBalance),
            icon: Icons.account_balance_wallet,
          ),
          StatCard(
            title: 'کۆی قەرزدان',
            value: AppFormatters.money(report.totalDebtGiven),
            icon: Icons.trending_up,
          ),
          StatCard(
            title: 'کۆی پارە وەرگرتن',
            value: AppFormatters.money(report.totalPaymentReceived),
            icon: Icons.payments,
          ),
          StatCard(
            title: 'کڕیارە چالاکەکان',
            value: '${report.activeCustomersCount}',
            icon: Icons.people,
          ),
          StatCard(
            title: 'ژمارەی پەسوولە',
            value: '${report.receiptsCount}',
            icon: Icons.receipt_long,
          ),
          if (weekly.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('ڕاپۆرتی هەفتانە', style: Theme.of(context).textTheme.titleMedium),
            StatCard(
              title: 'قەرزدان لەم هەفتەیە',
              value: AppFormatters.money(readNum(weekly, 'total_debt_given')),
              icon: Icons.trending_up,
            ),
            StatCard(
              title: 'پارە وەرگرتن لەم هەفتەیە',
              value: AppFormatters.money(readNum(weekly, 'total_payment_received')),
              icon: Icons.payments,
            ),
          ],
          if (monthly.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('ڕاپۆرتی مانگانە', style: Theme.of(context).textTheme.titleMedium),
            StatCard(
              title: 'قەرزدان لەم مانگە',
              value: AppFormatters.money(readNum(monthly, 'total_debt_given')),
              icon: Icons.trending_up,
            ),
            StatCard(
              title: 'پارە وەرگرتن لەم مانگە',
              value: AppFormatters.money(readNum(monthly, 'total_payment_received')),
              icon: Icons.payments,
            ),
          ],
          if (paidUnpaid.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('دۆخی کڕیاران', style: Theme.of(context).textTheme.titleMedium),
            StatCard(
              title: 'بێ قەرز',
              value: '${readCount(paidUnpaid, 'paid_count')}',
              icon: Icons.check_circle,
            ),
            StatCard(
              title: 'قەرزدار',
              value: '${readCount(paidUnpaid, 'unpaid_count')}',
              icon: Icons.warning_amber,
            ),
          ],
          if (topDebtors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('زۆرترین قەرزداران', style: Theme.of(context).textTheme.titleMedium),
            StatCard(
              title: 'ژمارەی قەرزداران',
              value: '${readListCount(topDebtors, 'items') + readListCount(topDebtors, 'top_debtors')}',
              icon: Icons.leaderboard,
            ),
          ],
        ],
      ),
    );
  }
}
