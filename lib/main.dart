import 'package:flutter/material.dart';

import 'app/app_root.dart';

void main() {
  runApp(const ZhiroxDebtApp());
}

class ZhiroxDebtApp extends StatelessWidget {
  const ZhiroxDebtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zhirox Debt Intelligence OS',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppRoot(),
    );
  }
}
