import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseService {
  static String get baseUrl =>  dotenv.env['BASE_URL'] ?? 'http://localhost/backend';

  static final Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static final Map<String, String> formHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // Common GET method
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    String url = '$baseUrl$endpoint';



    if (queryParams != null && queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url += '?$query';
    }

    try {
      final response = await http.get(Uri.parse(url));

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Common POST method with JSON body
  Future<dynamic> postJson(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: jsonHeaders,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Common POST method with form data
  Future<dynamic> postForm(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: formHeaders,
        body: data,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Common POST method with raw body
  Future<dynamic> postRaw(String endpoint, String body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: headers ?? jsonHeaders,
        body: body,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 500) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      throw Exception('Server error: ${response.statusCode} - ${response.body}');
    }
  }
}