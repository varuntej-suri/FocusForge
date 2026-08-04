import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../models/user_model.dart';
import '../../services/token_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserModel? user;

  bool isLoading = true;

  int totalSessions = 0;

  int totalMinutes = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final profile = await AuthApi.getProfile();

    if (!mounted) return;

    setState(() {
      user = profile;
      isLoading = false;
    });
  }

  Future<void> logout() async {

    await TokenService.removeToken();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }
    Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: color,
              size: 34,
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
                            const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                user?.name ?? "User",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user?.email ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              Row(
                children: [

                  buildStatCard(
                    icon: Icons.timer,
                    title: "Focus\nHours",
                    value: (totalMinutes / 60).toStringAsFixed(1),
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 15),

                  buildStatCard(
                    icon: Icons.task_alt,
                    title: "Sessions",
                    value: totalSessions.toString(),
                    color: Colors.green,
                  ),

                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  buildStatCard(
                    icon: Icons.local_fire_department,
                    title: "Current\nStreak",
                    value: "0",
                    color: Colors.red,
                  ),

                  const SizedBox(width: 15),

                  buildStatCard(
                    icon: Icons.emoji_events,
                    title: "Best\nStreak",
                    value: "0",
                    color: Colors.amber,
                  ),

                ],
              ),

              

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}