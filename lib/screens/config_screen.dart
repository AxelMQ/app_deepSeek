import 'package:app_deepseek/providers/theme_provider.dart';
import 'package:app_deepseek/services/api_config_service.dart';
import 'package:app_deepseek/widgets/custom_button.dart';
import 'package:app_deepseek/widgets/custom_text_field.dart';
import 'package:app_deepseek/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSaveUrl();
  }

  // Cargar la URL guardad
  Future<void> _loadSaveUrl() async {
    final savedUrl = await ApiConfigService.getApiUrl();
    if (savedUrl != null) {
      _urlController.text = savedUrl;
    }
  }

  // Guardar la nueva URL
  Future<void> _savedUrl() async {
    final newUrl = _urlController.text;
    if (newUrl.isNotEmpty) {
      await ApiConfigService.saveApiUrl(newUrl);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_box),
            Text('URL actualizada correctamente'),
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion de la API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _urlController,
              labelText: 'URL de la API',
              hintText: 'Ej: http://192.168.1.100/api',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Guardar URL',
              onPressed: _savedUrl,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              borderRadius: 12.0,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            ),
            const SizedBox(height: 20),
            // Botón para cambiar el tema
            const ThemeToggleButton(),
          ],
        ),
      ),
    );
  }
}
