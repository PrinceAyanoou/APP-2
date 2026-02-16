// Service for API calls to backend
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: Change to your backend URL when deploying
const String API_BASE_URL = 'http://localhost:5000/api';

class ApiService {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> _getAuthHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> signup(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$API_BASE_URL/auth/me'),
      headers: _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  // Profile endpoints
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$API_BASE_URL/profile'),
      headers: _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateProfile(
      Map<String, String> profileData) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/profile'),
      headers: _getAuthHeaders(),
      body: jsonEncode(profileData),
    );
    return _handleResponse(response);
  }

  // Requests endpoints
  static Future<Map<String, dynamic>> createRequest(
      String title, String type) async {
    final response = await http.post(
      Uri.parse('$API_BASE_URL/requests'),
      headers: _getAuthHeaders(),
      body: jsonEncode({'title': title, 'type': type}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getRequests() async {
    final response = await http.get(
      Uri.parse('$API_BASE_URL/requests'),
      headers: _getAuthHeaders(),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateRequest(
      String id, String status) async {
    final response = await http.put(
      Uri.parse('$API_BASE_URL/requests/$id'),
      headers: _getAuthHeaders(),
      body: jsonEncode({'status': status}),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['error'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
