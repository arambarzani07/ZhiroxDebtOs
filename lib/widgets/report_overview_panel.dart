import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../core/utils/response_reader.dart';
import '../models/daily_report_model.dart';
import 'stat_card.dart';

class ReportOverviewPanel extends StatelessWidget {
  const ReportOverviewPanel({
    super.key,
    required this.daily,
    this.weekly = const {},
    this.monthly = const {},
    this.topDebtors = const {},
    this.paidUnpaid = const {},
  });

  final DailyReportModel daily;
  final Map<String, dynamic> weekly;
  final Map<String, dynamic> monthly;
  final Map<String, dynamic> topDebtors;
  final Map<String, dynamic> paidUnpaid;

  @override
  Widget build(BuildContext context) {
    final debtors = _list(topDebtors, ['items', 'top_debtors', 'debtors', 'customers']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('ڕاپۆرتی ڕۆژانە', style: Theme.of(context).textTheme.titleMedium),
        StatCard(title: 'بەروار', value: daily.date, icon: Icons.calendar_month),
        StatCard(title: 'کۆی باڵانس', value: AppFormatters.money(daily.totalCurrentBalance), icon: Icons.account_balance_wallet),
        StatCard(title: 'کۆی قەرزدان', value: AppFormatters.money(daily.totalDebtGiven), icon: Icons.trending_up),
        StatCard(title: 'کۆی پارە وەرگرتن', value: AppFormatters.money(daily.totalPaymentReceived), icon: Icons.payments),
        StatCard(title: 'کڕیارە چالاکەکان', value: '${daily.activeCustomersCount}', icon: Icons.people),
        StatCard(title: 'ژمارەی پەسوولە', value: '${daily.receiptsCount}', icon: Icons.receipt_long),
        if (weekly.isNotEmpty) _PeriodReport(title: 'ڕاپۆرتی هەفتانە', data: weekly),
        if (monthly.isNotEmpty) _PeriodReport(title: 'ڕاپۆرتی مانگانە', data: monthly),
        if (paidUnpaid.isNotEmpty) _PaidUnpaidPanel(data: paidUnpaid),
        if (debtors.isNotEmpty) _TopDebtorsPanel(items: debtors),
      ],
    );
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final items = ResponseReader.listFrom(data[key]);
      if (items.isNotEmpty) return items;
    }
    final nested = ResponseReader.mapFrom(data['report']);
    for (final key in keys) {
      final items = ResponseReader.listFrom(nested[key]);
      if (items.isNotEmpty) return items;
    }
    return const [];
  }
}

class _PeriodReport extends StatelessWidget {
  const _PeriodReport({required this.title, required this.data});

  final String title;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          StatCard(title: 'قەرزدان', value: AppFormatters.money(_num(data, 'total_debt_given')), icon: Icons.trending_up),
          StatCard(title: 'پارە وەرگرتن', value: AppFormatters.money(_num(data, 'total_payment_received')), icon: Icons.payments),
          StatCard(title: 'کۆی باڵانس', value: AppFormatters.money(_num(data, 'total_current_balance')), icon: Icons.account_balance_wallet),
        ],
      ),
    );
  }

  num _num(Map<String, dynamic> data, String key) {
    final report = ResponseReader.mapFrom(data['report']);
    if (report.containsKey(key)) return AppFormatters.safeNum(report[key]);
    return AppFormatters.safeNum(data[key]);
  }
}

class _PaidUnpaidPanel extends StatelessWidget {
  const _PaidUnpaidPanel({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('دۆخی کڕیاران', style: Theme.of(context).textTheme.titleMedium),
          StatCard(title: 'بێ قەرز', value: '${_int('paid_count')}', icon: Icons.check_circle),
          StatCard(title: 'قەرزدار', value: '${_int('unpaid_count')}', icon: Icons.warning_amber),
        ],
      ),
    );
  }

  int _int(String key) {
    final report = ResponseReader.mapFrom(data['report']);
    if (report.containsKey(key)) return AppFormatters.safeInt(report[key]);
    return AppFormatters.safeInt(data[key]);
  }
}

class _TopDebtorsPanel extends StatelessWidget {
  const _TopDebtorsPanel({required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('زۆرترین قەرزداران', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...items.take(10).map((item) {
              final name = item['name'] ?? item['customer_name'] ?? item['full_name'] ?? 'کڕیار';
              final phone = item['phone'] ?? item['mobile'] ?? '';
              final balance = item['current_balance'] ?? item['balance'] ?? item['total_balance'] ?? 0;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person),
                title: Text('$name'),
                subtitle: phone == null || '$phone'.isEmpty ? null : Text('$phone'),
                trailing: Text(AppFormatters.money(balance)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
