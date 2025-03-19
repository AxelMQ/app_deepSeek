import 'package:app_deepseek/models/message_model.dart';
import 'package:app_deepseek/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<Message> _messages = [];
  bool _isLoading = false;

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
    } catch (e) {
      _addMessage('Error al obtener la respuesta: $e', false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addMessage(String text, bool isUserMessage, {String? model, int? tokensUsed}) {
    _messages.add(
      Message(
        text: text,
        isUserMessage: isUserMessage,
        model: model,
        tokensUsed: tokensUsed,
      ),
    );
    notifyListeners();
  }
}