import 'package:shared_preferences/shared_preferences.dart';

class ApiConfigService {
  static const String _apiUrlKey = 'api_url'; 
  static const String _apiKeyKey = 'api_key';

  // Guardar la URL de la API
  static Future<void> saveApiUrl(String url) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, url);
  }

  // Obtener la URL de la API
  static Future<String?> getApiUrl() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey);
  }

   // Guardar la API Key
  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  // Obtener la API Key
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }
}