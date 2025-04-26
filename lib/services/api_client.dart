import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late final Dio _dio; // Now private
  final String _baseUrl = dotenv.env['API_URL']!;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future clearAuthToken() async {
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
      final response = await _dio.post(endpoint, data: data, options: options);
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException error) {
    if (error.response != null) {
      throw Exception('API Error: ${error.response?.statusCode} - ${error.response?.data}');
    } else {
      throw Exception('API Error: ${error.message}');
    }
  }
}


  // void _handleDioError(DioException error) {
  //   final status = error.response?.statusCode;
  //   if (status == 401) {
  //     throw UnauthenticatedException(); // You define this
  //   } else if (status == 403) {
  //     throw ForbiddenException();
  //   } else {
  //     throw Exception('API Error: ${status} - ${error.response?.data}');
  //   }
  // }

  // Future<void> refreshTokenIfNeeded() async {
  //   // Use interceptors to auto-refresh on 401, if needed
  // }
