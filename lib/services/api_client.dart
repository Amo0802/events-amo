import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl;
  late final Dio _dio;

  ApiClient({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
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
      final response = await _dio.get(endpoint, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic body, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      final response = await _dio.post(endpoint, data: body, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic body, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      final response = await _dio.put(endpoint, data: body, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final options = await _getOptions(requiresAuth: requiresAuth);
      final response = await _dio.delete(endpoint, options: options);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
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
