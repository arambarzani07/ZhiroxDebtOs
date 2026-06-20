import 'package:flutter/material.dart';

import '../../models/daily_report_model.dart';
import '../../services/report_reader_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'daily_report_screen.dart';

class ReportLoader extends StatefulWidget {
  const ReportLoader({super.key, required this.service});

  final ReportReaderService service;

  @override
  State<ReportLoader> createState() => _ReportLoaderState();
}

class _ReportLoaderState extends State<ReportLoader> {
  late Future<DailyReportModel> future;

  @override
  void initState() {
    super.initState();
    future = widget.service.loadToday();
  }

  void reload() {
    setState(() => future = widget.service.loadToday());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyReportModel>(
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
        return DailyReportScreen(report: data, onRefresh: reload);
      },
    );
  }
}
