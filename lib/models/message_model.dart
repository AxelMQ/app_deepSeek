class Message {
  final String text;
  final bool
      isUserMessage; // true si es un mensaje del usuario, false si es del sistema

  Message({required this.text, required this.isUserMessage});
}
