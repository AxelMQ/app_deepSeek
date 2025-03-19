import 'package:app_deepseek/models/message_model.dart';
import 'package:app_deepseek/screens/config_screen.dart';
import 'package:app_deepseek/services/api_service.dart';
import 'package:app_deepseek/widgets/chat_input.dart';
import 'package:app_deepseek/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    try {
      await _apiService.checkApiConnection();
      setState(() {
        _messages.add(
          Message(
            text: 'Conexión exitosa con OpenRouter.',
            isUserMessage: false,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      print('--> Error: $e');
      setState(() {
        _messages.add(
          Message(
            text: 'Error al conectar con OpenRouter: $e',
            isUserMessage: false,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  // Función para enviar el mensaje
  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: message,
            isUserMessage: true,
          ),
        );
        _isLoading = true;
      });
      _messageController.clear();
      _scrollToBottom();

      try {
        final response = await _apiService.sendQuestion(message);
        setState(() {
          _messages.add(
            Message(
              text: response['respuesta'],
              isUserMessage: false,
              model: response['model'],
              tokensUsed: response['tokens_utilizados'],
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      } catch (e) {
        print('--> Error: $e');
        setState(() {
          _messages.add(
            Message(
                text: 'Error al obtener la respuesta: $e',
                isUserMessage: false),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escribe un mensaje'),
        ),
      );
    }
  }

  // Función para desplazar al final de la lista
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API DeepSeek - Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfigScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller:
                  _scrollController, // Asignar el controlador de desplazamiento
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                    message: message); // Usar el widget MessageBubble
              },
            ),
          ),
          // Input de chat
          Column(
            children: [
              if (_isLoading) // Mostrar el indicador de carga
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ChatInput(
                controller: _messageController,
                onSend: _sendMessage, // Usar el widget ChatInput
              ),
            ],
          ),
        ],
      ),
    );
  }
}
