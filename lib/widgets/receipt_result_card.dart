import 'package:flutter/material.dart';

class ReceiptResultCard extends StatelessWidget {
  const ReceiptResultCard({
    super.key,
    this.receiptId,
    this.currentBalance,
  });

  final int? receiptId;
  final num? currentBalance;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long),
                SizedBox(width: 8),
                Text(
                  'پسوولە دروست بوو',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (receiptId != null) Text('Receipt ID: $receiptId'),
            if (currentBalance != null) Text('Balance: $currentBalance IQD'),
          ],
        ),
      ),
    );
  }
}
