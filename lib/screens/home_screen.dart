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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await _apiService.fetchData();
      setState(() {
        // _data = data;
        _messages.add(Message(
            text: 'Data: $data',
            isUserMessage: false)); // Ejemplo de mensaje del sistema
      });
      _scrollToBottom();
    } catch (e) {
      print('--> Error: $e');
    }
  }

  // Función para enviar el mensaje
  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(
          Message(text: message, isUserMessage: true),
        ); // Agregar mensaje del usuario
      });
      _messageController.clear();
      _scrollToBottom();

      // Simular una respuesta del sistema (puedes reemplazar esto con una llamada a la API)
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
            Message(text: 'Respuesta a: $message', isUserMessage: false),
          ); // Agregar mensaje del sistema
        });
        _scrollToBottom();
      });
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
          ChatInput(
            controller: _messageController,
            onSend: _sendMessage, // Usar el widget ChatInput
          ),
        ],
      ),
    );
  }
}
