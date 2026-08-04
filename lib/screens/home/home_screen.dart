import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/session_card.dart';

import '../timer/timer_screen.dart';

import '../../services/token_service.dart';
import '../../services/notification_service.dart';

import '../../api/auth_api.dart';
import '../../api/session_api.dart';

import '../../models/user_model.dart';
import '../../models/focus_session_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedDuration = 90;
  int customDuration = 0;

  UserModel? user;
  List<FocusSession> sessions = [];

  int totalMinutes = 0;
  int totalSessions = 0;

  final TextEditingController customController =
      TextEditingController();

  String formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours == 0) {
      return "$mins min";
    }

    return "${hours}h ${mins}m";
  }

  Color getDurationColor() {

    if (customDuration == 0) {
      return Colors.grey;
    }

    if (customDuration <= 120) {
      return Colors.white;
    }

    if (customDuration <= 240) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadDashboard();
  }
    Future<void> loadProfile() async {
    UserModel? profile = await AuthApi.getProfile();

    if (!mounted) return;

    setState(() {
      user = profile;
    });
  }

  Future<void> loadDashboard() async {
    final data = await SessionApi.getSessions();

    int minutes = 0;

    for (var session in data) {
      if (session.completed) {
        minutes += session.duration;

      }
    }

    

    if (!mounted) return;

    setState(() {
      sessions = data;
      totalSessions = data.length;
      totalMinutes = minutes;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  String getGreetingEmoji() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "🌅";
    } else if (hour >= 12 && hour < 17) {
      return "☀️";
    } else if (hour >= 17 && hour < 21) {
      return "🌇";
    } else {
      return "🌙";
    }
  }

  String getMotivation() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Ready to achieve today's goals?";
    } else if (hour >= 12 && hour < 17) {
      return "Keep your momentum going!";
    } else if (hour >= 17 && hour < 21) {
      return "Finish your day with a focused session.";
    } else {
      return "Consistency today builds success tomorrow.";
    }
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        title: const Text("FocusForge"),

        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (!context.mounted) return;

              await TokenService.removeToken();

              if (!context.mounted) return;

              Navigator.of(context).pushNamedAndRemoveUntil(
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                user == null
                    ? "${getGreeting()} ${getGreetingEmoji()}"
                    : "${getGreeting()}, ${user!.name} ${getGreetingEmoji()}",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 4),

              Text(
                user?.email ?? "",
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 4),

              Text(
                getMotivation(),
                style: AppTextStyles.body.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "📊 Today's Progress",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "⏱ Focus Time",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          formatMinutes(totalMinutes),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "✅ Sessions",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          totalSessions.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Choose your focus session",
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [

                    SessionCard(
                      title: "⚡ Quick Focus",
                      duration: "25 Minutes",
                      description: "Perfect for short tasks",
                      isSelected: selectedDuration == 25,
                      onTap: () => setState(() => selectedDuration = 25),
                    ),

                    SessionCard(
                      title: "🚀 Deep Work",
                      duration: "45 Minutes",
                      description: "Stay productive",
                      isSelected: selectedDuration == 45,
                      onTap: () => setState(() => selectedDuration = 45),
                    ),

                    SessionCard(
                      title: "🔥 Ultra Focus",
                      duration: "90 Minutes",
                      description: "Maximum concentration",
                      isSelected: selectedDuration == 90,
                      onTap: () => setState(() => selectedDuration = 90),
                    ),

                    SessionCard(
                      title: "🧠 Marathon",
                      duration: "120 Minutes",
                      description: "Long uninterrupted work",
                      isSelected: selectedDuration == 120,
                      onTap: () => setState(() => selectedDuration = 120),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: showCustomTimerDialog,
                        icon: const Icon(Icons.timer),
                        label: const Text(
                          "Customize Timer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                            const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TimerScreen(
                                minutes: selectedDuration,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "START $selectedDuration MIN SESSION",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    width: 55,
                    height: 55,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.notifications),
                      onPressed: () async {
                        try {
                          await NotificationService
                              .showTestNotification();
                        } catch (e) {
                          // Ignore notification scheduling errors
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text(
                    "Session History",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/history",
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
void showCustomTimerDialog() {
  customController.clear();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Custom Focus Timer"),
        content: TextField(
          controller: customController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter minutes",
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (customController.text.isEmpty) return;

              final minutes =
                  int.tryParse(customController.text);

              if (minutes == null || minutes <= 0) {
                return;
              }

              setState(() {
                selectedDuration = minutes;
                customDuration = minutes;
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
  @override
  void dispose() {
    customController.dispose();
    super.dispose();
  }
}