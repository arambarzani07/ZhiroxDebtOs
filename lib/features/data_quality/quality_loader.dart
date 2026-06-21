import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../services/locked_backend_service.dart';
import '../../services/quality_service.dart';
import '../../widgets/error_view.dart';
import 'data_quality_screen.dart';

class QualityLoader extends StatefulWidget {
  const QualityLoader({super.key, required this.service, this.lockedBackend});

  final QualityServiceApi service;
  final LockedBackendService? lockedBackend;

  @override
  State<QualityLoader> createState() => _QualityLoaderState();
}

class _QualityLoaderState extends State<QualityLoader> {
  Map<String, dynamic>? result;
  bool loading = false;

  Future<void> run() async {
    setState(() => loading = true);
    try {
      final data = widget.lockedBackend == null
          ? await widget.service.runCheck()
          : ResponseReader.mapFrom(await widget.lockedBackend!.dataQualityScan());
      if (mounted) setState(() => result = data);
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> runFix(Future<dynamic> Function(LockedBackendService service) action) async {
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return;
    setState(() => loading = true);
    try {
      final response = await action(lockedBackend);
      if (!mounted) return;
      setState(() => result = ResponseReader.mapFrom(response));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('چاککردنەوە تەواو بوو')));
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
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
      onFixMissingProfiles: widget.lockedBackend == null
          ? null
          : () => runFix((service) => service.fixMissingProfile()),
      onFixReceiptLinks: widget.lockedBackend == null
          ? null
          : () => runFix((service) => service.fixReceiptLink()),
      onFixSelectedBalance: widget.lockedBackend == null
          ? null
          : (customerId) => runFix((service) => service.fixCustomerBalance(customerId)),
    );
  }
}
