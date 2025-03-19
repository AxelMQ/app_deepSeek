import 'package:app_deepseek/models/message_model.dart';
import 'package:app_deepseek/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<Message> _messages = [];
  bool _isLoading = false;
  final FlutterTts _flutterTts;

  ChatController(this._flutterTts);

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> checkApiConnection() async {
    try {
      await _apiService.checkApiConnection();
      _addMessage('Conexión exitosa.', false);
    } catch (e) {
      _addMessage('Error al conectar : $e', false);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    _addMessage(message, true);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.sendQuestion(message);
      _addMessage(
        response['respuesta'],
        false,
        model: response['model'],
        tokensUsed: response['tokens_utilizados'],
      );

      // Lee la respuesta en voz alta
      await _speak(response['respuesta']);
    } catch (e) {
      _addMessage('Error al obtener la respuesta: $e', false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(_cleanText(text)); // Lee el texto en voz alta
  }

  String _cleanText(String text) {
    // Expresión regular para eliminar emoticonos
    final emojiRegex = RegExp(
        r'[\u{1F600}-\u{1F64F}' // Emoticons
        r'\u{1F300}-\u{1F5FF}' // Símbolos de emociones
        r'\u{1F680}-\u{1F6FF}' // Símbolos de transporte y mapas
        r'\u{2600}-\u{26FF}' // Símbolos varios
        r'\u{2700}-\u{27BF}' // Símbolos de dingbats
        r'\u{1F900}-\u{1F9FF}]' // Símbolos suplementarios
        ,
        unicode: true);
    // Elimina los caracteres de Markdown como **, *, _, etc.
    return text
        .replaceAll(emojiRegex, '') // Elimina los emoticonos
        .replaceAll('**', '') // Elimina los asteriscos dobles
        .replaceAll('*', '') // Elimina los asteriscos simples
        .replaceAll('_', ''); // Elimina los guiones bajos
  }

  void _addMessage(String text, bool isUserMessage,
      {String? model, int? tokensUsed}) {
    _messages.add(
      Message(
        text: text,
        isUserMessage: isUserMessage,
        model: model,
        tokensUsed: tokensUsed,
      ),
    );
    notifyListeners();
    // Lee el mensaje en voz alta si no es del usuario
    if (!isUserMessage) {
      _speak(text);
    }
  }
}
