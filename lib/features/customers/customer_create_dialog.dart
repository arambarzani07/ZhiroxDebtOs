import 'package:flutter/material.dart';

class CustomerCreateInput {
  const CustomerCreateInput({
    required this.fullName,
    required this.phone,
    this.address = '',
  });

  final String fullName;
  final String phone;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'name': fullName,
      'phone': phone,
      'mobile': phone,
      if (address.isNotEmpty) 'address': address,
      'status': 'active',
    };
  }
}

class CustomerCreateDialog extends StatefulWidget {
  const CustomerCreateDialog({super.key});

  @override
  State<CustomerCreateDialog> createState() => _CustomerCreateDialogState();
}

class _CustomerCreateDialogState extends State<CustomerCreateDialog> {
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  @override
  void dispose() {
    fullName.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  void submit() {
    final nameText = fullName.text.trim();
    final phoneText = phone.text.trim();
    if (nameText.isEmpty || phoneText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ناو و ژمارەی مۆبایل پێویستن')),
      );
      return;
    }
    Navigator.of(context).pop(
      CustomerCreateInput(
        fullName: nameText,
        phone: phoneText,
        address: address.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('کڕیاری نوێ'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fullName,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'ناوی کڕیار'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'ژمارەی مۆبایل'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: address,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'ناونیشان'),
              onSubmitted: (_) => submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('داخستن'),
        ),
        FilledButton.icon(
          onPressed: submit,
          icon: const Icon(Icons.person_add),
          label: const Text('زیادکردن'),
        ),
      ],
    );
  }
}
