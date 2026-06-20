import 'package:flutter/material.dart';

import '../models/financial_event_model.dart';

class FinancialResultPanel extends StatelessWidget {
  const FinancialResultPanel({super.key, required this.result});

  final FinancialEventResultModel result;

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
          ],
        ),
      ),
    );
  }
}
