import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../core/utils/response_reader.dart';
import 'stat_card.dart';

class SettingsOverviewPanel extends StatelessWidget {
  const SettingsOverviewPanel({
    super.key,
    required this.settings,
    required this.permissions,
    required this.license,
  });

  final Map<String, dynamic> settings;
  final Map<String, dynamic> permissions;
  final Map<String, dynamic> license;

  @override
  Widget build(BuildContext context) {
    final currency = _text(settings, ['default_currency', 'currency'], fallback: 'IQD');
    final timezone = _text(settings, ['timezone'], fallback: 'Asia/Baghdad');
    final licenseStatus = _text(license, ['status', 'license_status', 'plan_status'], fallback: 'trial');
    final plan = _text(license, ['plan', 'plan_name', 'license_plan'], fallback: '—');
    final role = _text(permissions, ['role', 'user_role', 'name'], fallback: 'loaded');
    final permissionCount = _countPermissions(permissions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatCard(title: 'دراوی بنەڕەتی', value: currency, icon: Icons.payments),
        StatCard(title: 'Timezone', value: timezone, icon: Icons.schedule),
        StatCard(title: 'License', value: AppFormatters.statusLabel(licenseStatus), icon: Icons.verified_user),
        StatCard(title: 'Plan', value: plan, icon: Icons.workspace_premium),
        StatCard(title: 'ڕۆڵ / Permission', value: '$role / $permissionCount', icon: Icons.admin_panel_settings),
      ],
    );
  }

  String _text(Map<String, dynamic> map, List<String> keys, {String fallback = '—'}) {
    for (final key in keys) {
      final value = ResponseReader.pick(map, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    final data = ResponseReader.mapFrom(map['data']);
    for (final key in keys) {
      final value = ResponseReader.pick(data, [key]);
      if (value != null && '$value'.trim().isNotEmpty) return '$value';
    }
    return fallback;
  }

  int _countPermissions(Map<String, dynamic> map) {
    final items = ResponseReader.listFrom(map['permissions'] ?? map['items'] ?? map['data']);
    if (items.isNotEmpty) return items.length;
    final nested = ResponseReader.mapFrom(map['permissions']);
    return nested.length;
  }
}
