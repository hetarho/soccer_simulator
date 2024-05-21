import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soccer_simulator/router/routes.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  await Hive.initFlutter();
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
        textTheme: TextTheme(
          labelLarge: GoogleFonts.rubikMarkerHatch(fontSize: 16),
          headlineMedium: GoogleFonts.rubikMarkerHatch(fontSize: 26),
          bodySmall: GoogleFonts.rubikMarkerHatch(fontSize: 12),
          bodyMedium: GoogleFonts.rubikMarkerHatch(),
          bodyLarge: GoogleFonts.rubikMarkerHatch(fontSize: 18),
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
