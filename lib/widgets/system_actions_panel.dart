import 'dart:convert';

import 'package:flutter/material.dart';

class SystemActionsPanel extends StatelessWidget {
  const SystemActionsPanel({
    super.key,
    required this.loading,
    this.result,
    this.onExportCustomers,
    this.onExportReports,
    this.onExportReceipts,
    this.onManagerBroadcast,
  });

  final bool loading;
  final Map<String, dynamic>? result;
  final VoidCallback? onExportCustomers;
  final VoidCallback? onExportReports;
  final VoidCallback? onExportReceipts;
  final VoidCallback? onManagerBroadcast;

  @override
  Widget build(BuildContext context) {
    final data = result;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ئامرازەکانی سیستەم', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onExportCustomers,
                  icon: const Icon(Icons.people_alt_outlined),
                  label: const Text('Export customers'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onExportReports,
                  icon: const Icon(Icons.summarize_outlined),
                  label: const Text('Export reports'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onExportReceipts,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Export receipts'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onManagerBroadcast,
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('Broadcast draft'),
                ),
              ],
            ),
            if (data != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              Text('ئەنجام', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SelectableText(const JsonEncoder.withIndent('  ').convert(data)),
            ],
          ],
        ),
      ),
    );
  }
}
