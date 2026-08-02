import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../api/auth_api.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> signup() async {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthApi.registerUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (result["success"]) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created Successfully 🎉"),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');

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
                  Icons.person_add_alt_1_rounded,
                  size: 90,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Join FocusForge",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 35),

                CustomTextField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 18),

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

                const SizedBox(height: 18),

                CustomTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscureText: obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: isLoading ? "Creating..." : "CREATE ACCOUNT",
                  onPressed: () async {
                    if (isLoading) return;
                    await signup();
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Login"),
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