import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/utils/response_reader.dart';
import 'stat_card.dart';

class DataQualityResultPanel extends StatelessWidget {
  const DataQualityResultPanel({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final issues = _issuesFrom(data);
    final fixed = ResponseReader.listFrom(data['fixed'] ?? data['fixed_items'] ?? data['repairs']);
    final warnings = ResponseReader.listFrom(data['warnings']);
    final issueCount = data['issues_found'] ?? issues.length;
    final scanCompleted = data['scan_completed'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatCard(
          title: 'کێشەکان',
          value: '$issueCount',
          icon: Icons.warning_amber,
        ),
        StatCard(
          title: 'دۆخی پشکنین',
          value: scanCompleted ? 'تەواو بوو' : 'ناتەواو',
          icon: Icons.check_circle,
        ),
        const SizedBox(height: 12),
        if (issues.isEmpty && warnings.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('هیچ کێشەیەکی داتا نەدۆزرایەوە.'),
            ),
          ),
        if (issues.isNotEmpty) _IssueList(title: 'کێشە دۆزراوەکان', items: issues),
        if (fixed.isNotEmpty) _IssueList(title: 'چاککراوەکان', items: fixed),
        if (warnings.isNotEmpty) _IssueList(title: 'ئاگادارییەکان', items: warnings),
        ExpansionTile(
          title: const Text('وردەکاری خام'),
          children: [SelectableText(const JsonEncoder.withIndent('  ').convert(data))],
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _issuesFrom(Map<String, dynamic> data) {
    final raw = data['issues'] ??
        data['data_issues'] ??
        data['problems'] ??
        data['items'] ??
        data['missing_profiles'] ??
        data['balance_mismatches'];
    return ResponseReader.listFrom(raw);
  }
}

class _IssueList extends StatelessWidget {
  const _IssueList({required this.title, required this.items});

  final String title;
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...items.take(20).map((item) => _IssueTile(item: item)),
          ],
        ),
      ),
    );
  }
}

class _IssueTile extends StatelessWidget {
  const _IssueTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final type = _pick(['type', 'issue_type', 'code', 'category']);
    final message = _pick(['message', 'description', 'title', 'error']);
    final customerId = _pick(['customer_id', 'customerId']);
    final ledgerId = _pick(['ledger_entry_id', 'ledgerEntryId']);
    final receiptId = _pick(['receipt_id', 'receiptId']);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.report_problem_outlined),
      title: Text(message.isEmpty ? (type.isEmpty ? 'کێشەی داتا' : type) : message),
      subtitle: Text([
        if (type.isNotEmpty) 'جۆر: $type',
        if (customerId.isNotEmpty) 'کڕیار: $customerId',
        if (ledgerId.isNotEmpty) 'Ledger: $ledgerId',
        if (receiptId.isNotEmpty) 'Receipt: $receiptId',
      ].join('  •  ')),
    );
  }

  String _pick(List<String> keys) {
    for (final key in keys) {
      final value = ResponseReader.pick(item, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    return '';
  }
}
