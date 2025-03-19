import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final VoidCallback onMicPressed; // Función para manejar el micrófono
  final bool isListening; // Estado de grabación

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMicPressed,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // Botón de enviar
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = controller.text;
              if (message.isNotEmpty) {
                onSend(message);
                controller.clear();
              }
            },
          ), 
          const SizedBox(width: 8.0),
          // Botón de micrófono
          IconButton(
            icon: Icon(
              isListening
                  ? Icons.mic_off
                  : Icons.mic, // Cambia el ícono según el estado
            ),
            onPressed: onMicPressed,
          ),
        ],
      ),
    );
  }
}
