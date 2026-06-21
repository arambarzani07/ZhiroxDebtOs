import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.riskLevel});

  final String riskLevel;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.shield, size: 18),
      label: Text('مەترسی: ${AppFormatters.riskLabel(riskLevel)}'),
    );
  }
}

class DebtHealthBadge extends StatelessWidget {
  const DebtHealthBadge({super.key, required this.health});

  final String health;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.favorite, size: 18),
      label: Text('دۆخی قەرز: ${AppFormatters.debtHealthLabel(health)}'),
    );
  }
}
