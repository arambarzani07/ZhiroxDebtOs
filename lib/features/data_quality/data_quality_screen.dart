import 'dart:convert';

import 'package:flutter/material.dart';

import '../../widgets/stat_card.dart';

class DataQualityScreen extends StatelessWidget {
  const DataQualityScreen({
    super.key,
    required this.result,
    required this.loading,
    required this.onScan,
  });

  final Map<String, dynamic>? result;
  final bool loading;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final data = result;
    return Scaffold(
      appBar: AppBar(title: const Text('پشکنینی داتا')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: loading ? null : onScan,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.health_and_safety),
            label: const Text('Scan'),
          ),
          const SizedBox(height: 16),
          if (data == null)
            const Text('هێشتا هیچ پشکنینێک نەکراوە')
          else ...[
            StatCard(
              title: 'کێشەکان',
              value: '${data['issues_found'] ?? 0}',
              icon: Icons.warning_amber,
            ),
            StatCard(
              title: 'دۆخ',
              value: data['scan_completed'] == true ? 'تەواو بوو' : 'ناتەواو',
              icon: Icons.check_circle,
            ),
            const SizedBox(height: 12),
            SelectableText(const JsonEncoder.withIndent('  ').convert(data)),
          ],
        ],
      ),
    );
  }
}
