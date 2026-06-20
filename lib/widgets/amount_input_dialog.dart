import 'package:flutter/material.dart';

class AmountInputResult {
  const AmountInputResult({required this.amount, this.note = ''});

  final num amount;
  final String note;
}

Future<AmountInputResult?> showAmountInputDialog({
  required BuildContext context,
  required String title,
}) async {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  return showDialog<AmountInputResult>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'بڕی پارە',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'تێبینی',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('پاشگەزبوونەوە'),
          ),
          FilledButton(
            onPressed: () {
              final amount = num.tryParse(amountController.text.trim()) ?? 0;
              if (amount <= 0) return;
              Navigator.pop(
                context,
                AmountInputResult(
                  amount: amount,
                  note: noteController.text.trim(),
                ),
              );
            },
            child: const Text('دڵنیاکردنەوە'),
          ),
        ],
      );
    },
  );
}
