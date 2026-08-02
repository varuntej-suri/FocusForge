import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../api/auth_api.dart';
import '../../services/token_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<void> login() async {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthApi.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (result["success"]) {

      // Get JWT Token
      String token = result["data"]["access_token"];

      // Save Token
      await TokenService.saveToken(token);
      String? savedToken = await TokenService.getToken();

      print("Saved JWT:");
      print(savedToken);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful 🎉"),
        ),
      );

      Navigator.pushReplacementNamed(context, "/home");

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [

                const Icon(
                  Icons.timer_rounded,
                  size: 90,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                const Text(
                  "FocusForge",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Stay Focused. Stay Productive.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 45),

                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: isLoading ? "Logging In..." : "LOGIN",
                  onPressed: () async {
                    if (isLoading) return;
                    await login();
                  },
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}