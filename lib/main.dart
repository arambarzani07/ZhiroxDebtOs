import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ZhiroxDebtApp());
}

class ApiConfig {
  static const String authBaseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:zhirox-auth';

  static String group(String slug) => authBaseUrl.replaceFirst('zhirox-auth', slug);

  static String get customers => group('zhirox-customers');
  static String get financialEvents => group('zhirox-financial-events');
  static String get approvals => group('zhirox-approvals');
  static String get dashboard => group('zhirox-dashboard');
  static String get reports => group('zhirox-reports');
  static String get receipts => group('zhirox-receipts');
  static String get dataQuality => group('zhirox-data-quality');
}

class TokenStorage {
  static const _tokenKey = 'zhirox_auth_token';

  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this.storage);
  final TokenStorage storage;

  Future<dynamic> get(String baseUrl, String path, {Map<String, dynamic>? query}) {
    return _send('GET', baseUrl, path, query: query);
  }

  Future<dynamic> post(String baseUrl, String path, {Map<String, dynamic>? body}) {
    return _send('POST', baseUrl, path, body: body);
  }

  Future<dynamic> _send(
    String method,
    String baseUrl,
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final token = await storage.readToken();
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, '$value')),
    );

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = method == 'GET'
        ? await http.get(uri, headers: headers)
        : await http.post(uri, headers: headers, body: jsonEncode(body ?? {}));

    dynamic decoded;
    try {
      decoded = response.body.isEmpty ? {} : jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'API error ${response.statusCode}';
      throw ApiException(message);
    }
    return decoded;
  }
}

class AuthService {
  AuthService(this.client, this.storage);
  final ApiClient client;
  final TokenStorage storage;

  Future<void> login(String email, String password) async {
    final data = await client.post(ApiConfig.authBaseUrl, '/login', body: {
      'email': email,
      'password': password,
    });

    final token = data['authToken'] ?? data['auth_token'] ?? data['token'];
    if (token == null || token.toString().isEmpty) {
      throw ApiException('Login succeeded but no token was returned.');
    }
    await storage.saveToken(token.toString());
  }

  Future<Map<String, dynamic>> me() async {
    final data = await client.get(ApiConfig.authBaseUrl, '/me');
    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> logout() async {
    try {
      await client.post(ApiConfig.authBaseUrl, '/logout');
    } catch (_) {}
    await storage.clear();
  }
}

class CustomerService {
  CustomerService(this.client);
  final ApiClient client;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await client.get(ApiConfig.customers, '/list');
    final raw = data is List ? data : (data['customers'] ?? data['data'] ?? []);
    return List<Map<String, dynamic>>.from(raw.map((e) => Map<String, dynamic>.from(e)));
  }

  Future<Map<String, dynamic>> getById(int id) async {
    final data = await client.get(ApiConfig.customers, '/id', query: {'id': id});
    return Map<String, dynamic>.from(data as Map);
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final data = await client.post(ApiConfig.customers, '/create', body: body);
    return Map<String, dynamic>.from(data as Map);
  }
}

class FinancialService {
  FinancialService(this.client);
  final ApiClient client;

  Future<Map<String, dynamic>> debt({
    required int customerId,
    required num amount,
    required String description,
  }) async {
    final data = await client.post(ApiConfig.financialEvents, '/debt', body: {
      'customer_id': customerId,
      'amount': amount,
      'currency': 'IQD',
      'description': description,
      'reference_number': 'APP-DEBT-${DateTime.now().millisecondsSinceEpoch}',
    });
    return Map<String, dynamic>.from(data as Map);
  }

  Future<Map<String, dynamic>> payment({
    required int customerId,
    required num amount,
    required String description,
  }) async {
    final data = await client.post(ApiConfig.financialEvents, '/payment', body: {
      'customer_id': customerId,
      'amount': amount,
      'currency': 'IQD',
      'description': description,
      'reference_number': 'APP-PAY-${DateTime.now().millisecondsSinceEpoch}',
    });
    return Map<String, dynamic>.from(data as Map);
  }
}

class ApprovalService {
  ApprovalService(this.client);
  final ApiClient client;

  Future<Map<String, dynamic>> approve(int id) async {
    final data = await client.post(ApiConfig.approvals, '/approve', body: {'id': id});
    return Map<String, dynamic>.from(data as Map);
  }
}

class DashboardService {
  DashboardService(this.client);
  final ApiClient client;

  Future<Map<String, dynamic>> summary() async {
    final data = await client.get(ApiConfig.dashboard, '/summary');
    return Map<String, dynamic>.from(data as Map);
  }
}

class ReportsService {
  ReportsService(this.client);
  final ApiClient client;

  Future<Map<String, dynamic>> daily({int branchId = 0, String? date}) async {
    final selectedDate = date ?? DateTime.now().toIso8601String().substring(0, 10);
    final data = await client.get(ApiConfig.reports, '/daily', query: {
      'branch_id': branchId,
      'date': selectedDate,
    });
    return Map<String, dynamic>.from(data as Map);
  }
}

String money(dynamic value) {
  final n = num.tryParse('$value') ?? 0;
  final text = n.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return '$text IQD';
}

Map<String, dynamic> profileOf(Map<String, dynamic> data) {
  if (data['profile'] is Map) return Map<String, dynamic>.from(data['profile']);
  if (data['customer_profile'] is Map) return Map<String, dynamic>.from(data['customer_profile']);
  if (data['customer'] is Map && data['customer']['profile'] is Map) {
    return Map<String, dynamic>.from(data['customer']['profile']);
  }
  return {};
}

Map<String, dynamic> customerOf(Map<String, dynamic> data) {
  if (data['customer'] is Map) return Map<String, dynamic>.from(data['customer']);
  return data;
}

class ZhiroxDebtApp extends StatefulWidget {
  const ZhiroxDebtApp({super.key});

  @override
  State<ZhiroxDebtApp> createState() => _ZhiroxDebtAppState();
}

class _ZhiroxDebtAppState extends State<ZhiroxDebtApp> {
  final storage = TokenStorage();

  @override
  Widget build(BuildContext context) {
    final client = ApiClient(storage);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zhirox Debt OS',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF273B8E),
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: AuthGate(
        storage: storage,
        client: client,
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.storage, required this.client});
  final TokenStorage storage;
  final ApiClient client;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = widget.storage.readToken();
  }

  void _refresh() => setState(() => _tokenFuture = widget.storage.readToken());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if ((snapshot.data ?? '').isEmpty) {
          return LoginScreen(
            authService: AuthService(widget.client, widget.storage),
            onLoggedIn: _refresh,
          );
        }
        return AppShell(
          client: widget.client,
          storage: widget.storage,
          onLogout: _refresh,
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService, required this.onLoggedIn});
  final AuthService authService;
  final VoidCallback onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: 'admin@zhirox.os');
  final password = TextEditingController(text: '123123123');
  bool loading = false;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      await widget.authService.login(email.text.trim(), password.text);
      widget.onLoggedIn();
    } catch (e) {
      if (mounted) _showError(context, e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shield_outlined, size: 72, color: Color(0xFF273B8E)),
                const SizedBox(height: 16),
                const Text(
                  'Zhirox Debt Intelligence OS',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('سیستەمی پاراستنی پارە و بەڕێوەبردنی قەرز', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'ئیمەیڵ', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'وشەی نهێنی', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: loading ? null : submit,
                  icon: loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.login),
                  label: const Text('چوونەژوورەوە'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.client, required this.storage, required this.onLogout});
  final ApiClient client;
  final TokenStorage storage;
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(service: DashboardService(widget.client)),
      CustomersScreen(
        customerService: CustomerService(widget.client),
        financialService: FinancialService(widget.client),
        approvalService: ApprovalService(widget.client),
      ),
      DailyReportScreen(service: ReportsService(widget.client)),
      SettingsScreen(authService: AuthService(widget.client, widget.storage), onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'داشبۆرد'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'کڕیارەکان'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'ڕاپۆرت'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'ڕێکخستن'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.service});
  final DashboardService service;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = widget.service.summary();
  }

  void reload() => setState(() => future = widget.service.summary());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('داشبۆردی پاراستنی پارە'), actions: [IconButton(onPressed: reload, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final data = snapshot.data ?? {};
          return RefreshIndicator(
            onRefresh: () async => reload(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                StatCard(title: 'کۆی قەرزی ماوە', value: money(data['total_current_balance']), icon: Icons.account_balance_wallet),
                StatCard(title: 'کۆی قەرزدان', value: money(data['total_debt_given']), icon: Icons.trending_up),
                StatCard(title: 'کۆی پارەدانەوە', value: money(data['total_payment_received']), icon: Icons.payments),
                StatCard(title: 'کڕیارە چالاکەکان', value: '${data['active_customers_count'] ?? 0}', icon: Icons.people),
                StatCard(title: 'چاوەڕوانی ڕەزامەندی', value: '${data['pending_approvals_count'] ?? 0}', icon: Icons.verified_user),
                StatCard(title: 'قەرزی ئەمڕۆ', value: money(data['today_debt_given']), icon: Icons.today),
                StatCard(title: 'پارەدانی ئەمڕۆ', value: money(data['today_payment_received']), icon: Icons.done_all),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({
    super.key,
    required this.customerService,
    required this.financialService,
    required this.approvalService,
  });

  final CustomerService customerService;
  final FinancialService financialService;
  final ApprovalService approvalService;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() {
    super.initState();
    future = widget.customerService.list();
  }

  void reload() => setState(() => future = widget.customerService.list());

  Future<void> createCustomer() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CreateCustomerScreen(service: widget.customerService)),
    );
    if (created == true) reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کڕیارەکان'), actions: [IconButton(onPressed: reload, icon: const Icon(Icons.refresh))]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createCustomer,
        icon: const Icon(Icons.person_add),
        label: const Text('کڕیاری نوێ'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final customers = snapshot.data ?? [];
          if (customers.isEmpty) return const Center(child: Text('هێشتا هیچ کڕیارێک نییە'));
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: customers.length,
            itemBuilder: (context, i) {
              final c = customers[i];
              final id = c['id'] as int? ?? int.tryParse('${c['id']}') ?? 0;
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${c['full_name'] ?? 'بێ ناو'}'),
                  subtitle: Text('${c['phone'] ?? ''}'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerProfileScreen(
                          customerId: id,
                          customerService: widget.customerService,
                          financialService: widget.financialService,
                          approvalService: widget.approvalService,
                        ),
                      ),
                    );
                    reload();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({
    super.key,
    required this.customerId,
    required this.customerService,
    required this.financialService,
    required this.approvalService,
  });

  final int customerId;
  final CustomerService customerService;
  final FinancialService financialService;
  final ApprovalService approvalService;

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late Future<Map<String, dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = widget.customerService.getById(widget.customerId);
  }

  void reload() => setState(() => future = widget.customerService.getById(widget.customerId));

  Future<void> addDebt() async {
    final amount = await askAmount(context, title: 'قەرزدان');
    if (amount == null) return;
    try {
      final result = await widget.financialService.debt(customerId: widget.customerId, amount: amount, description: 'Debt from mobile app');
      if (result['status'] == 'pending_approval') {
        final approvalId = int.tryParse('${result['approval_request_id']}');
        if (approvalId != null && mounted) await askApproval(context, approvalId);
      }
      reload();
    } catch (e) {
      if (mounted) _showError(context, e.toString());
    }
  }

  Future<void> askApproval(BuildContext context, int approvalId) async {
    final approve = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('پێویستی بە ڕەزامەندی هەیە'),
        content: Text('Credit limit تێپەڕیوە. Approval ID: $approvalId'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('دواتر')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('قبووڵکردن')),
        ],
      ),
    );
    if (approve == true) {
      await widget.approvalService.approve(approvalId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ڕەزامەندی سەرکەوتوو بوو')));
    }
  }

  Future<void> addPayment() async {
    final amount = await askAmount(context, title: 'پارە وەرگرتن');
    if (amount == null) return;
    try {
      await widget.financialService.payment(customerId: widget.customerId, amount: amount, description: 'Payment from mobile app');
      reload();
    } catch (e) {
      if (mounted) _showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debt Passport'), actions: [IconButton(onPressed: reload, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final data = snapshot.data ?? {};
          final customer = customerOf(data);
          final profile = profileOf(data);
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${customer['full_name'] ?? ''}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${customer['phone'] ?? ''}'),
                    const Divider(height: 28),
                    Row(children: [
                      Expanded(child: StatMini(title: 'Balance', value: money(profile['current_balance']))),
                      Expanded(child: StatMini(title: 'Limit', value: money(profile['credit_limit']))),
                    ]),
                    Row(children: [
                      Expanded(child: StatMini(title: 'Trust', value: '${profile['trust_score'] ?? 0}')),
                      Expanded(child: StatMini(title: 'Risk', value: '${profile['risk_level'] ?? 'low'}')),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: FilledButton.icon(onPressed: addDebt, icon: const Icon(Icons.add_card), label: const Text('قەرزدان')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(onPressed: addPayment, icon: const Icon(Icons.payments), label: const Text('پارە وەرگرتن')),
                ),
              ]),
              const SizedBox(height: 12),
              StatCard(title: 'کۆی قەرزدان', value: money(profile['total_debt_given']), icon: Icons.trending_up),
              StatCard(title: 'کۆی پارەدانەوە', value: money(profile['total_payment_received']), icon: Icons.trending_down),
              StatCard(title: 'Discount', value: money(profile['total_discount']), icon: Icons.discount),
            ],
          );
        },
      ),
    );
  }
}

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key, required this.service});
  final CustomerService service;

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final limit = TextEditingController(text: '500000');
  bool loading = false;

  Future<void> submit() async {
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) return;
    setState(() => loading = true);
    try {
      await widget.service.create({
        'full_name': name.text.trim(),
        'phone': phone.text.trim(),
        'secondary_phone': '',
        'address': '',
        'notes': 'Created from Flutter app',
        'branch_id': 0,
        'credit_limit': num.tryParse(limit.text.trim()) ?? 0,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _showError(context, e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کڕیاری نوێ')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'ناوی تەواو', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'ژمارەی مۆبایل', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: limit, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Credit Limit', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        FilledButton(onPressed: loading ? null : submit, child: const Text('دروستکردن')),
      ]),
    );
  }
}

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({super.key, required this.service});
  final ReportsService service;

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  late Future<Map<String, dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = widget.service.daily(branchId: 0);
  }

  void reload() => setState(() => future = widget.service.daily(branchId: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ڕاپۆرتی ڕۆژانە'), actions: [IconButton(onPressed: reload, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final data = snapshot.data ?? {};
          final report = Map<String, dynamic>.from((data['report'] ?? {}) as Map);
          return ListView(padding: const EdgeInsets.all(12), children: [
            StatCard(title: 'بەروار', value: '${data['date'] ?? ''}', icon: Icons.calendar_month),
            StatCard(title: 'کۆی Balance', value: money(report['total_current_balance']), icon: Icons.account_balance_wallet),
            StatCard(title: 'کۆی قەرزدان', value: money(report['total_debt_given']), icon: Icons.trending_up),
            StatCard(title: 'کۆی پارەدانەوە', value: money(report['total_payment_received']), icon: Icons.payments),
            StatCard(title: 'کڕیارە چالاکەکان', value: '${report['active_customers_count'] ?? 0}', icon: Icons.people),
            StatCard(title: 'Receipt', value: '${report['receipts_count'] ?? 0}', icon: Icons.receipt),
          ]);
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.authService, required this.onLogout});
  final AuthService authService;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ڕێکخستن')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('API Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SelectableText(ApiConfig.authBaseUrl),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () async {
            await authService.logout();
            onLogout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('چوونەدەرەوە'),
        ),
      ]),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class StatMini extends StatelessWidget {
  const StatMini({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: const Text('دووبارە هەوڵبدە')),
        ]),
      ),
    );
  }
}

Future<num?> askAmount(BuildContext context, {required String title}) async {
  final controller = TextEditingController();
  return showDialog<num>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'بڕ بە IQD', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('پاشگەزبوونەوە')),
        FilledButton(
          onPressed: () => Navigator.pop(context, num.tryParse(controller.text.trim())),
          child: const Text('تۆمارکردن'),
        ),
      ],
    ),
  );
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
}
