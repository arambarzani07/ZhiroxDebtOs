import 'package:flutter/material.dart';

class FinancialActionBar extends StatelessWidget {
  const FinancialActionBar({
    super.key,
    required this.onDebt,
    required this.onPayment,
    this.loading = false,
  });

  final VoidCallback onDebt;
  final VoidCallback onPayment;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: loading ? null : onDebt,
            icon: const Icon(Icons.add_card),
            label: const Text('قەرزدان'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: loading ? null : onPayment,
            icon: const Icon(Icons.payments),
            label: const Text('پارە وەرگرتن'),
          ),
        ),
      ],
    );
  }
}
