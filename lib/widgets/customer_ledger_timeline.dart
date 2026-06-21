import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../models/ledger_entry_model.dart';

class CustomerLedgerTimeline extends StatelessWidget {
  const CustomerLedgerTimeline({super.key, required this.entries});

  final List<LedgerEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'هێشتا هیچ مامەڵەیەک لە statement ـی ئەم کڕیارەدا نییە.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Statement / Ledger', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...entries.map((entry) => _LedgerTile(entry: entry)),
          ],
        ),
      ),
    );
  }
}

class _LedgerTile extends StatelessWidget {
  const _LedgerTile({required this.entry});

  final LedgerEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment = entry.isIncrease ? Alignment.centerRight : Alignment.centerLeft;
    final amountPrefix = entry.isIncrease ? '+' : '-';
    final amount = AppFormatters.money(entry.amount, currency: entry.currency);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.title, style: theme.textTheme.titleSmall),
                const SizedBox(width: 8),
                Text(
                  '$amountPrefix $amount',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('باڵانسی نوێ: ${AppFormatters.money(entry.newBalance, currency: entry.currency)}'),
            if (entry.note.isNotEmpty) Text('تێبینی: ${entry.note}'),
            if (entry.createdAt.isNotEmpty) Text('کات: ${entry.createdAt}'),
            if (entry.receiptId != null) Text('Receipt ID: ${entry.receiptId}'),
            Text('Status: ${entry.status}'),
          ],
        ),
      ),
    );
  }
}
