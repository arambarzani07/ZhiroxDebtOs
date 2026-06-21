import 'package:flutter/material.dart';

import '../../models/daily_report_model.dart';
import '../../widgets/report_overview_panel.dart';

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
          ReportOverviewPanel(
            daily: report,
            weekly: weekly,
            monthly: monthly,
            topDebtors: topDebtors,
            paidUnpaid: paidUnpaid,
          ),
        ],
      ),
    );
  }
}
