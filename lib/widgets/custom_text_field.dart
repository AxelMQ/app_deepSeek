import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Theme.of(context)
            .colorScheme
            .onSurface, // Color del texto ingresado
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .onSurface, // Color del texto de la etiqueta
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor, // Color del hintText
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outline, // Color del borde cuando no está enfocado
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .primary, // Color del borde cuando está enfocado
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface, // Color de fondo
      ),
    );
  }
}
