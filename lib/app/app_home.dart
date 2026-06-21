import 'package:flutter/material.dart';

import '../core/config/api_endpoints.dart';
import '../features/app_shell/app_shell.dart';
import '../features/dashboard/dashboard_loader.dart';
import '../features/customers/customer_loader_small.dart';
import '../features/customers/customer_profile_route.dart';
import '../features/reports/report_loader.dart';
import '../features/data_quality/quality_loader.dart';
import '../features/settings/settings_screen.dart';
import 'app_services.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key, required this.services, required this.onLogout});

  final AppServices services;
  final VoidCallback onLogout;

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      pages: [
        DashboardLoader(service: widget.services.dashboard),
        CustomerLoaderSmall(
          service: widget.services.customers,
          onOpen: (customer) => openCustomerProfile(
            context: context,
            customer: customer,
            services: widget.services,
          ),
        ),
        ReportLoader(
          service: widget.services.reports,
          lockedBackend: widget.services.lockedBackend,
        ),
        QualityLoader(service: widget.services.quality),
        SettingsScreen(apiBaseUrl: ApiEndpoints.base, onLogout: widget.onLogout),
      ],
    );
  }
}
