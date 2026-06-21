import 'package:flutter/material.dart';

import 'risk_badge.dart';
import 'stat_card.dart';

class CustomerBalanceCard extends StatelessWidget {
  const CustomerBalanceCard({
    super.key,
    required this.customerName,
    required this.phone,
    required this.currentBalance,
    required this.creditLimit,
    required this.trustScore,
    required this.riskLevel,
    required this.debtHealth,
  });

  final String customerName;
  final String phone;
  final String currentBalance;
  final String creditLimit;
  final String trustScore;
  final String riskLevel;
  final String debtHealth;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customerName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(phone),
            const Divider(height: 28),
            StatLine(title: 'باڵانس', value: currentBalance),
            StatLine(title: 'سنوری قەرز', value: creditLimit),
            StatLine(title: 'Trust score', value: trustScore),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                RiskBadge(riskLevel: riskLevel),
                DebtHealthBadge(health: debtHealth),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
