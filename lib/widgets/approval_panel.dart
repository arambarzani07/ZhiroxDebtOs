import 'package:flutter/material.dart';

class ApprovalPanel extends StatelessWidget {
  const ApprovalPanel({
    super.key,
    required this.approvalId,
    required this.onConfirm,
  });

  final int approvalId;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ڕەزامەندی پێویستە',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('ID: $approvalId'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onConfirm,
              child: const Text('قبووڵکردن'),
            ),
          ],
        ),
      ),
    );
  }
}
