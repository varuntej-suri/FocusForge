import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class FocusForgeApp extends StatelessWidget {
  const FocusForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FocusForge",
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}