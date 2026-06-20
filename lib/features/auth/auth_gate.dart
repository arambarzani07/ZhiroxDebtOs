import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.tokenFuture,
    required this.loginPage,
    required this.homePage,
  });

  final Future<String?> tokenFuture;
  final Widget loginPage;
  final Widget homePage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data ?? '';
        if (token.isEmpty) {
          return loginPage;
        }

        return homePage;
      },
    );
  }
}
