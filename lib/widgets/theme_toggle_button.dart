import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_deepseek/providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return SwitchListTile(
      title: const Text('Modo oscuro'),
      secondary: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? Icons.nightlight_round // Ícono de luna para el modo oscuro
            : Icons.wb_sunny, // Ícono de sol para el modo claro
      ),
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        themeProvider.toggleTheme(value);
      },
    );
  }
}