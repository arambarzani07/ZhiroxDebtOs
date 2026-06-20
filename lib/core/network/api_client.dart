import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this.storage);

  final TokenStorage storage;

  Future<dynamic> get(
    String baseUrl,
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _send('GET', baseUrl, path, query: query);
  }

  Future<dynamic> post(
    String baseUrl,
    String path, {
    Map<String, dynamic>? body,
  }) {
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
      decoded = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
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
