import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Para procesar Markdown
import 'package:app_deepseek/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensaje principal (formateado en Markdown)
            MarkdownBody(
              data: message.text, // Usa MarkdownBody para mostrar el texto
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: message.isUserMessage
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
                strong: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: message.isUserMessage
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            // Mostrar el modelo y los tokens utilizados (si están disponibles)
            if (!message.isUserMessage &&
                message.model != null &&
                message.tokensUsed != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Modelo: ${message.model}, Tokens: ${message.tokensUsed}',
                  style: TextStyle(
                    color: message.isUserMessage
                        ? Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7)
                        : Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.7),
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
