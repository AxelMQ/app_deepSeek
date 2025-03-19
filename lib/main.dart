import 'package:app_deepseek/controllers/chat_controller.dart';
import 'package:app_deepseek/providers/theme_provider.dart';
import 'package:app_deepseek/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa flutter_tts
  final flutterTts = FlutterTts();
  await flutterTts.setLanguage('es-ES'); // Configura el idioma a español
  await flutterTts.setSpeechRate(0.5); // Velocidad de habla (0.0 a 1.0)
  await flutterTts.setVolume(1.0); // Volumen (0.0 a 1.0)
  await flutterTts.setPitch(1.0); // Tono (0.5 a 2.0)

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChatController(flutterTts)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'DeepSeek API',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.dosisTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.dosisTextTheme(),
      ),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
