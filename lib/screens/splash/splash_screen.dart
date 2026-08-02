import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../home/home_screen.dart';
import '../../services/token_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
void initState() {
  super.initState();
  checkLogin();
}

Future<void> checkLogin() async {

  bool loggedIn = await TokenService.isLoggedIn();

  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return;

  if (loggedIn) {

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );

  } else {

    Navigator.pushReplacementNamed(
      context,
      '/login',
    );

  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.local_fire_department,
              color: AppColors.primary,
              size: 90,
            ),

            const SizedBox(height: 20),

            Text(
              "FocusForge",
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 10),

            Text(
              "Forge Your Focus",
              style: AppTextStyles.body.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}