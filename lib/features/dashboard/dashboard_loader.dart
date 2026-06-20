import 'package:flutter/material.dart';

import '../../models/dashboard_summary_model.dart';
import '../../services/dashboard_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'dashboard_screen.dart';

class DashboardLoader extends StatefulWidget {
  const DashboardLoader({super.key, required this.service});

  final DashboardServiceApi service;

  @override
  State<DashboardLoader> createState() => _DashboardLoaderState();
}

class _DashboardLoaderState extends State<DashboardLoader> {
  late Future<DashboardSummaryModel> future;

  @override
  void initState() {
    super.initState();
    future = widget.service.summary();
  }

  void reload() {
    setState(() => future = widget.service.summary());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardSummaryModel>(
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
        return DashboardScreen(summary: data, onRefresh: reload);
      },
    );
  }
}
