import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer_simulator/ui/router/routes.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        textTheme: const TextTheme(
          labelLarge: TextStyle(fontFamily: 'Jaro'),
          titleLarge: TextStyle(fontFamily: 'Jaro'),
          titleMedium: TextStyle(fontFamily: 'Jaro'),
          titleSmall: TextStyle(fontFamily: 'Jaro'),
          headlineLarge: TextStyle(fontFamily: 'Jaro'),
          headlineMedium: TextStyle(fontFamily: 'Jaro'),
          headlineSmall: TextStyle(fontFamily: 'Jaro'),
          bodySmall: TextStyle(fontFamily: 'Jaro'),
          bodyMedium: TextStyle(fontFamily: 'Jaro'),
          bodyLarge: TextStyle(fontFamily: 'Jaro'),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // korean
      ],
      routerConfig: router,
    );
  }
}
