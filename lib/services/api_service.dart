import 'package:app_deepseek/services/api_config_service.dart';
import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

   ApiService() {
    _dio = Dio();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final baseUrl = await ApiConfigService.getApiUrl();
        final apiKey = await ApiConfigService.getApiKey();

         if (baseUrl != null) {
          options.baseUrl = baseUrl;
        }
        if (apiKey != null) {
          options.headers['Authorization'] = 'Bearer $apiKey';
        }
        return handler.next(options);
      },
    ));
  }

  // Método para verificar la conexión con la API
  Future<dynamic> checkApiConnection() async {
    try {
      // Envía una solicitud simple para verificar la conexión
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'deepseek/deepseek-r1:free',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant'},
            {'role': 'user', 'content': 'Hola'},
          ],
        },
      );
      return response.data; // Devuelve la respuesta para verificar la conexión
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

// Método para enviar una pregunta al servidor
  Future<dynamic> sendQuestion(String question) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'deepseek/deepseek-r1:free',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant'},
            {'role': 'user', 'content': question},
          ],
        },
      );
      return {
        'respuesta': response.data['choices'][0]['message']['content'],
        'model': response.data['model'],
        'tokens_utilizados': response.data['usage']['total_tokens'],
      };
    } catch (e) {
      throw Exception('Failed to send question: $e');
    }
  }
}
