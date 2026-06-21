import 'dart:convert';

import 'package:flutter/material.dart';

import '../../widgets/stat_card.dart';

class DataQualityScreen extends StatelessWidget {
  const DataQualityScreen({
    super.key,
    required this.result,
    required this.loading,
    required this.onScan,
    this.onFixMissingProfiles,
    this.onFixReceiptLinks,
    this.onFixSelectedBalance,
  });

  final Map<String, dynamic>? result;
  final bool loading;
  final VoidCallback onScan;
  final VoidCallback? onFixMissingProfiles;
  final VoidCallback? onFixReceiptLinks;
  final ValueChanged<int>? onFixSelectedBalance;

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
            label: const Text('پشکنین'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: loading ? null : onFixMissingProfiles,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('چاککردنی profile ـی ونبوو'),
              ),
              FilledButton.tonalIcon(
                onPressed: loading ? null : onFixReceiptLinks,
                icon: const Icon(Icons.receipt_long),
                label: const Text('چاککردنی receipt link'),
              ),
              FilledButton.tonalIcon(
                onPressed: loading ? null : () => _askCustomerId(context),
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('چاککردنی باڵانسی کڕیار'),
              ),
            ],
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

  Future<void> _askCustomerId(BuildContext context) async {
    final callback = onFixSelectedBalance;
    if (callback == null) return;
    final controller = TextEditingController();
    final customerId = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ژمارەی کڕیار'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Customer ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('داخستن'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(int.tryParse(controller.text.trim())),
            child: const Text('چاککردن'),
          ),
        ],
      ),
    );
    if (customerId != null) callback(customerId);
  }
}
