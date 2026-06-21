import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../core/utils/response_reader.dart';

class ToolResultPanel extends StatelessWidget {
  const ToolResultPanel({super.key, required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final receipts = ResponseReader.listFrom(result['receipts'] ?? result['items'] ?? result['data']);
    final message = _firstText(result, ['message', 'text', 'body', 'draft_message', 'whatsapp_message']);
    final exportUrl = _firstText(result, ['download_url', 'file_url', 'url', 'export_url']);
    final jobStatus = _firstText(result, ['status', 'job_status', 'state']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('ئەنجامی کردار', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (receipts.isNotEmpty) _ReceiptList(receipts: receipts),
        if (message.isNotEmpty) _MessageCard(message: message),
        if (exportUrl.isNotEmpty || jobStatus.isNotEmpty)
          _ExportCard(status: jobStatus, url: exportUrl),
        if (receipts.isEmpty && message.isEmpty && exportUrl.isEmpty && jobStatus.isEmpty)
          _RawResult(result: result),
      ],
    );
  }

  String _firstText(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = ResponseReader.pick(map, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    final nested = ResponseReader.mapFrom(map['draft']);
    for (final key in keys) {
      final value = ResponseReader.pick(nested, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    final job = ResponseReader.mapFrom(map['job']);
    for (final key in keys) {
      final value = ResponseReader.pick(job, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    return '';
  }
}

class _ReceiptList extends StatelessWidget {
  const _ReceiptList({required this.receipts});

  final List<Map<String, dynamic>> receipts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('پەسوولەکان: ${receipts.length}'),
        const SizedBox(height: 6),
        ...receipts.take(5).map((receipt) {
          final amount = receipt['amount'] ?? receipt['total_amount'] ?? receipt['paid_amount'] ?? 0;
          final number = receipt['receipt_number'] ?? receipt['id'] ?? '—';
          final status = receipt['status'] ?? '—';
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.receipt_long),
            title: Text('پەسوولە: $number'),
            subtitle: Text('دۆخ: ${AppFormatters.statusLabel(status)}'),
            trailing: Text(AppFormatters.money(amount)),
          );
        }),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SelectableText(message),
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({required this.status, required this.url});

  final String status;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.file_download_done),
      title: Text(status.isEmpty ? 'Export job' : AppFormatters.statusLabel(status)),
      subtitle: url.isEmpty ? null : SelectableText(url),
    );
  }
}

class _RawResult extends StatelessWidget {
  const _RawResult({required this.result});

  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    return SelectableText(const JsonEncoder.withIndent('  ').convert(result));
  }
}
