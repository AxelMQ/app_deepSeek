import 'package:app_deepseek/screens/config_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; 
import 'package:app_deepseek/controllers/chat_controller.dart'; // Importa el ChatController
import 'package:app_deepseek/widgets/chat_input.dart';
import 'package:app_deepseek/widgets/message_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText(); // Instancia de SpeechToText
  bool _isListening = false; // Estado de grabación

  @override
  void initState() {
    super.initState();
    // Verificar la conexión con la API al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatController = Provider.of<ChatController>(context, listen: false);
      chatController.checkApiConnection();
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

   // Iniciar o detener la grabación de voz
  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords; // Actualiza el campo de texto
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);

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
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          // Input de chat
          Column(
            children: [
              if (chatController.isLoading) // indicador de carga
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ChatInput(
                controller: _messageController,
                onSend: (message) {
                  chatController.sendMessage(message);
                  _scrollToBottom();
                },
                onMicPressed: _toggleListening, // Pasar la función de grabación
                isListening: _isListening, // Pasar el estado de grabación
              ),
            ],
          ),
        ],
      ),
    );
  }
}