import 'package:app_deepseek/services/api_config_service.dart';
import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion de la API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL de la API',
                hintText: 'Ej: http://192.168.1.100/api',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savedUrl,
              child: const Text('Guardar URL'),
            )
          ],
        ),
      ),
    );
  }
}
