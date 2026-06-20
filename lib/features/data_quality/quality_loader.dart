import 'package:flutter/material.dart';

import '../../services/quality_service.dart';
import 'data_quality_screen.dart';

class QualityLoader extends StatefulWidget {
  const QualityLoader({super.key, required this.service});

  final QualityServiceApi service;

  @override
  State<QualityLoader> createState() => _QualityLoaderState();
}

class _QualityLoaderState extends State<QualityLoader> {
  Map<String, dynamic>? result;
  bool loading = false;

  Future<void> run() async {
    setState(() => loading = true);
    try {
      final data = await widget.service.runCheck();
      setState(() => result = data);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataQualityScreen(
      result: result,
      loading: loading,
      onScan: run,
    );
  }
}
