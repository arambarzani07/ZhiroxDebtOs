import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.apiBaseUrl,
    required this.onLogout,
  });

  final String apiBaseUrl;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ڕێکخستن')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'API Base URL',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(apiBaseUrl),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('چوونەدەرەوە'),
          ),
        ],
      ),
    );
  }
}
