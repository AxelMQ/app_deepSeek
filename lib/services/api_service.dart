import 'package:app_deepseek/services/api_config_service.dart';
import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    // Interceptor para usar la URL guardada
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final baseUrl = await ApiConfigService.getApiUrl();
      options.baseUrl = baseUrl ?? 'http://192.168.100.2:8000';
      return handler.next(options);
    }));
  }

  Future<dynamic> checkServerConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

// Método para enviar una pregunta al servidor
  Future<dynamic> sendQuestion(String question) async {
    try {
      final response = await _dio.post(
        '/preguntar',
        data: {'text': question},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to send question: $e');
    }
  }
}
