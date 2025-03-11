import 'package:flutter/material.dart';
import 'package:app_deepseek/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: message.isUserMessage
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUserMessage
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
