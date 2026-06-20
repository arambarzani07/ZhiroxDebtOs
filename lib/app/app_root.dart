import 'package:flutter/material.dart';

import '../core/config/api_endpoints.dart';
import '../features/auth/auth_gate.dart';
import '../features/auth/login_screen.dart';
import 'app_home.dart';
import 'app_services.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final services = AppServices();
  bool loading = false;

  Future<void> login(String email, String password) async {
    setState(() => loading = true);
    try {
      final data = await services.apiClient.post(
        ApiEndpoints.base,
        '/login',
        body: {'email': email, 'password': password},
      );
      final map = Map<String, dynamic>.from(data as Map);
      final token = '${map['authToken'] ?? map['token'] ?? ''}';
      if (token.isEmpty) {
        throw Exception('Token نەگەڕایەوە');
      }
      await services.storage.saveToken(token);
      if (mounted) setState(() {});
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> logout() async {
    await services.storage.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      tokenFuture: services.storage.readToken(),
      loginPage: LoginScreen(onSubmit: login, loading: loading),
      homePage: AppHome(
        services: services,
        onLogout: logout,
      ),
    );
  }
}
