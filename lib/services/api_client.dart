import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late final Dio _dio;
  final String _baseUrl;

  ApiClient._internal() : _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080' {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Options> _getOptions({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return Options(headers: headers);
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      print('GET Request to: $_baseUrl$endpoint');
      final response = await _dio.get(endpoint, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, dynamic body, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      print('POST Request to: $_baseUrl$endpoint');
      final response = await _dio.post(endpoint, data: body, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, dynamic body, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      print('PUT Request to: $_baseUrl$endpoint');
      final response = await _dio.put(endpoint, data: body, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      print('DELETE Request to: $_baseUrl$endpoint');
      final response = await _dio.delete(endpoint, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> postFormData(String endpoint, FormData data, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      print('POST FormData to: $_baseUrl$endpoint');
      final response = await _dio.post(endpoint, data: data, options: options);
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException error) {
    final status = error.response?.statusCode;
    final responseData = error.response?.data;
    
    print('API Error: Status Code: $status');
    print('Response data: $responseData');
    
    if (status == 401) {
      throw Exception('Unauthorized: Your session may have expired. Please log in again.');
    } else if (status == 403) {
      throw Exception('Forbidden: You don\'t have permission to access this resource.');
    } else if (status == 404) {
      throw Exception('Not found: The requested resource could not be found.');
    } else if (status == 500) {
      throw Exception('Server error: Something went wrong on the server.');
    } else {
      throw Exception('API Error: ${error.message}');
    }
  }
}