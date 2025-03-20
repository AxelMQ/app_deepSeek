import 'package:app_deepseek/screens/config_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Verificar la conexión con la API al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatController =
          Provider.of<ChatController>(context, listen: false);
      chatController.checkApiConnection();

      // Configurar el callback para el texto reconocido
      chatController.setOnTextRecognized((text) {
        setState(() {
          _messageController.text = text; // Actualiza el campo de texto
        });
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    final chatController = Provider.of<ChatController>(context, listen: false);
    if (chatController.isListening) {
      chatController.toggleListening();
    }
    super.dispose();
  }

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
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: Consumer<ChatController>(
              builder: (context, chatController, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          // Mostrar mensaje si está escuchando
          Consumer<ChatController>(
            builder: (context, chatController, child) {
              if (chatController.isListening) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hearing, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Escuchando...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Loading
          // Input de chat
          Column(
            children: [
              Consumer<ChatController>(
                builder: (context, chatController, child) {
                  if (chatController.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              ChatInput(
                controller: _messageController,
                onSend: (message) {
                  final chatController =
                      Provider.of<ChatController>(context, listen: false);
                  chatController.sendMessage(message);
                  _scrollToBottom();
                },
                onMicPressed: () {
                  final chatController =
                      Provider.of<ChatController>(context, listen: false);
                  chatController.toggleListening();
                },
                isListening: Provider.of<ChatController>(context).isListening,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
