import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/session_card.dart';
import '../timer/timer_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDuration = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        centerTitle: true,
        title: const Text("FocusForge"),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Good Evening 👋",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              Text(
                "Choose your focus session",
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView(
                  children: [

                    SessionCard(
                      title: "⚡ Quick Focus",
                      duration: "25 Minutes",
                      description: "Perfect for short tasks",
                      isSelected: selectedDuration == 25,
                      onTap: () {
                        setState(() {
                          selectedDuration = 25;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🚀 Deep Work",
                      duration: "45 Minutes",
                      description: "Stay productive",
                      isSelected: selectedDuration == 45,
                      onTap: () {
                        setState(() {
                          selectedDuration = 45;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🔥 Ultra Focus",
                      duration: "90 Minutes",
                      description: "Maximum concentration",
                      isSelected: selectedDuration == 90,
                      onTap: () {
                        setState(() {
                          selectedDuration = 90;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🧠 Marathon",
                      duration: "120 Minutes",
                      description: "Long uninterrupted work",
                      isSelected: selectedDuration == 120,
                      onTap: () {
                        setState(() {
                          selectedDuration = 120;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerScreen(
                        minutes: selectedDuration,
                      ),
                    ),
                  );
                },

                  child: const Text(
                    "START FOCUS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}