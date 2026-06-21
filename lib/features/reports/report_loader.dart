import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../models/daily_report_model.dart';
import '../../services/locked_backend_service.dart';
import '../../services/report_daily_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'daily_report_screen.dart';

class ReportLoader extends StatefulWidget {
  const ReportLoader({super.key, required this.service, this.lockedBackend});

  final ReportDailyService service;
  final LockedBackendService? lockedBackend;

  @override
  State<ReportLoader> createState() => _ReportLoaderState();
}

class ReportLoadResult {
  const ReportLoadResult({
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
}

class _ReportLoaderState extends State<ReportLoader> {
  late Future<ReportLoadResult> future;

  @override
  void initState() {
    super.initState();
    future = loadReports();
  }

  Future<ReportLoadResult> loadReports() async {
    final daily = await widget.service.today();
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return ReportLoadResult(daily: daily);

    Future<Map<String, dynamic>> safeMap(Future<dynamic> call) async {
      try {
        return ResponseReader.mapFrom(await call);
      } catch (_) {
        return const {};
      }
    }

    final weekly = await safeMap(lockedBackend.reportWeekly());
    final monthly = await safeMap(lockedBackend.reportMonthly());
    final topDebtors = await safeMap(lockedBackend.reportTopDebtors(limit: 10));
    final paidUnpaid = await safeMap(lockedBackend.reportPaidUnpaid());

    return ReportLoadResult(
      daily: daily,
      weekly: weekly,
      monthly: monthly,
      topDebtors: topDebtors,
      paidUnpaid: paidUnpaid,
    );
  }

  void reload() {
    setState(() => future = loadReports());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReportLoadResult>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage());
        }
        if (snapshot.hasError) {
          return Scaffold(body: ErrorView(message: snapshot.error.toString(), onRetry: reload));
        }
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(body: ErrorView(message: 'No data', onRetry: reload));
        }
        return DailyReportScreen(
          report: data.daily,
          weekly: data.weekly,
          monthly: data.monthly,
          topDebtors: data.topDebtors,
          paidUnpaid: data.paidUnpaid,
          onRefresh: reload,
        );
      },
    );
  }
}
