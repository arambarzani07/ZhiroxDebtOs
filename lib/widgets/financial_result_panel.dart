import 'package:flutter/material.dart';

import '../models/financial_event_model.dart';

class FinancialResultPanel extends StatelessWidget {
  const FinancialResultPanel({
    super.key,
    required this.result,
    this.onApprove,
    this.onReject,
    this.loading = false,
  });

  final FinancialEventResultModel result;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final needsApproval = result.needsApproval;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(needsApproval ? Icons.verified_user_outlined : Icons.check_circle_outline),
                const SizedBox(width: 8),
                Text(
                  needsApproval ? 'پێویستی بە ڕەزامەندی هەیە' : 'کارەکە تۆمار کرا',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Balance: ${result.currentBalance} IQD'),
            if (result.approvalRequestId != null) Text('Approval ID: ${result.approvalRequestId}'),
            if (result.receiptId != null) Text('Receipt ID: ${result.receiptId}'),
            if (result.message.isNotEmpty) Text(result.message),
            if (needsApproval && onApprove != null && onReject != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: loading ? null : onApprove,
                      child: const Text('ڕەزامەندی'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: loading ? null : onReject,
                      child: const Text('ڕەتکردنەوە'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
