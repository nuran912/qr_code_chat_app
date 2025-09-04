import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_chat_app/firebase_options.dart';
import 'package:qr_chat_app/services/auth/auth_gate.dart';
import 'package:qr_chat_app/services/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final neonGreen = const Color(0xFF39FF14);
    final bgDark = const Color.fromARGB(255, 0, 20, 49);
    final appBarDark = const Color.fromARGB(255, 0, 32, 79);
    final cardDark = const Color.fromARGB(255, 0, 40, 100);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: neonGreen,
          brightness: Brightness.dark,
          primary: neonGreen,
          secondary: neonGreen,
          surface: Colors.grey[900],
          background: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: neonGreen,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: neonGreen,
          displayColor: neonGreen,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: neonGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: neonGreen, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: neonGreen),
          ),
          hintStyle: TextStyle(color: neonGreen.withOpacity(0.7)),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: neonGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: AuthGate(),
    );
  }
}
