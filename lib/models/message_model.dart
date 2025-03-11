class Message {
  final String text;
  final bool
      isUserMessage; // true si es un mensaje del usuario, false si es del sistema
  final String? model;
  final int? tokensUsed;

  Message({
    required this.text,
    required this.isUserMessage,
    this.model,
    this.tokensUsed,
  });
}
