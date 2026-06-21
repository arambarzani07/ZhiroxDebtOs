import 'dart:convert';

import 'package:flutter/material.dart';

class ReceiptVerifyPanel extends StatelessWidget {
  const ReceiptVerifyPanel({
    super.key,
    required this.loading,
    this.result,
    this.onVerify,
  });

  final bool loading;
  final Map<String, dynamic>? result;
  final ValueChanged<String>? onVerify;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final data = result;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('پشتڕاستکردنەوەی پەسوولە', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Verify token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: loading || onVerify == null
                  ? null
                  : () {
                      final token = controller.text.trim();
                      if (token.isNotEmpty) onVerify!(token);
                    },
              icon: const Icon(Icons.verified),
              label: const Text('پشتڕاستکردنەوە'),
            ),
            if (data != null) ...[
              const SizedBox(height: 12),
              SelectableText(const JsonEncoder.withIndent('  ').convert(data)),
            ],
          ],
        ),
      ),
    );
  }
}
