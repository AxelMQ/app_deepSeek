import 'package:app_deepseek/services/api_config_service.dart';
import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    // Interceptor para usar la URL guardada
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final baseUrl = await ApiConfigService.getApiUrl();
        options.baseUrl = baseUrl ?? 'http://127.0.0.1/api';
        return handler.next(options);
      }
    ));
  }
  
  Future<dynamic> fetchData() async {
    try {
      final response = await _dio.get('/endpoint');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

}