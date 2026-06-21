import 'package:flutter/material.dart';

import 'tool_result_panel.dart';

class CustomerProfileTools extends StatelessWidget {
  const CustomerProfileTools({
    super.key,
    required this.loading,
    this.toolResult,
    this.onShowReceipts,
    this.onPaymentReminderDraft,
    this.onCustomerStatementDraft,
    this.onExportLedger,
  });

  final bool loading;
  final Map<String, dynamic>? toolResult;
  final VoidCallback? onShowReceipts;
  final VoidCallback? onPaymentReminderDraft;
  final VoidCallback? onCustomerStatementDraft;
  final VoidCallback? onExportLedger;

  @override
  Widget build(BuildContext context) {
    final result = toolResult;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ئامرازەکانی کڕیار', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onShowReceipts,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('پەسوولەکان'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onPaymentReminderDraft,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('یادخستنەوەی پارە'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onCustomerStatementDraft,
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('نامەی statement'),
                ),
                FilledButton.tonalIcon(
                  onPressed: loading ? null : onExportLedger,
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Export ledger'),
                ),
              ],
            ),
            if (result != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              ToolResultPanel(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
