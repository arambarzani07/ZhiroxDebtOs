import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../services/locked_backend_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/receipt_verify_panel.dart';
import '../../widgets/settings_overview_panel.dart';
import '../../widgets/system_actions_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.apiBaseUrl,
    required this.onLogout,
    this.lockedBackend,
  });

  final String apiBaseUrl;
  final VoidCallback onLogout;
  final LockedBackendService? lockedBackend;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> marketSettings = const {};
  Map<String, dynamic> permissions = const {};
  Map<String, dynamic> license = const {};
  Map<String, dynamic>? receiptVerifyResult;
  Map<String, dynamic>? actionResult;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return;
    setState(() => loading = true);
    try {
      final settingsData = ResponseReader.mapFrom(await lockedBackend.marketSettings());
      final permissionsData = ResponseReader.mapFrom(await lockedBackend.permissions());
      Map<String, dynamic> licenseData = const {};
      final marketId = _readMarketId(settingsData);
      if (marketId != null) {
        licenseData = ResponseReader.mapFrom(await lockedBackend.licenseStatus(marketId));
      }
      if (!mounted) return;
      setState(() {
        marketSettings = settingsData;
        permissions = permissionsData;
        license = licenseData;
      });
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> verifyReceipt(String token) async {
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return;
    setState(() => loading = true);
    try {
      final data = ResponseReader.mapFrom(await lockedBackend.receiptVerify(token));
      if (!mounted) return;
      setState(() => receiptVerifyResult = data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پەسوولە پشکنرا')));
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> runSystemAction(Future<dynamic> Function(LockedBackendService service) action) async {
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return;
    setState(() => loading = true);
    try {
      final data = ResponseReader.mapFrom(await action(lockedBackend));
      if (!mounted) return;
      setState(() => actionResult = data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کردارەکە تەواو بوو')));
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> askBroadcastMessage() async {
    final controller = TextEditingController();
    final message = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('پەیامی broadcast'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(
            labelText: 'پەیام',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('داخستن'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Draft'),
          ),
        ],
      ),
    );
    if (message == null || message.isEmpty) return;
    await runSystemAction((service) => service.managerBroadcastDraft(message));
  }

  int? _readMarketId(Map<String, dynamic> data) {
    final nested = data['settings'];
    final value = data['market_id'] ?? (nested is Map ? nested['market_id'] : null);
    if (value == null) return null;
    return int.tryParse('$value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕێکخستن'),
        actions: [
          IconButton(
            onPressed: loading ? null : load,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'API Base URL',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(widget.apiBaseUrl),
          const SizedBox(height: 16),
          if (widget.lockedBackend != null) ...[
            SettingsOverviewPanel(
              settings: marketSettings,
              permissions: permissions,
              license: license,
            ),
            const SizedBox(height: 12),
            ReceiptVerifyPanel(
              loading: loading,
              result: receiptVerifyResult,
              onVerify: verifyReceipt,
            ),
            const SizedBox(height: 12),
            SystemActionsPanel(
              loading: loading,
              result: actionResult,
              onExportCustomers: () => runSystemAction((service) => service.exportCustomers()),
              onExportReports: () => runSystemAction((service) => service.exportReports(reportType: 'summary')),
              onExportReceipts: () => runSystemAction((service) => service.exportReceipts()),
              onManagerBroadcast: askBroadcastMessage,
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              title: const Text('Market Settings JSON'),
              children: [SelectableText(const JsonEncoder.withIndent('  ').convert(marketSettings))],
            ),
            ExpansionTile(
              title: const Text('Permissions JSON'),
              children: [SelectableText(const JsonEncoder.withIndent('  ').convert(permissions))],
            ),
            if (license.isNotEmpty)
              ExpansionTile(
                title: const Text('License JSON'),
                children: [SelectableText(const JsonEncoder.withIndent('  ').convert(license))],
              ),
          ],
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('چوونەدەرەوە'),
          ),
        ],
      ),
    );
  }
}
