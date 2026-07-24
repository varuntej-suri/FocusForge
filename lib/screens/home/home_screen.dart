import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedMinutes = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("FocusForge"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Good Evening 👋",
              style: AppTextStyles.heading,
            ),

            const SizedBox(height: 10),

            Text(
              "Choose your focus session",
              style: AppTextStyles.body,
            ),

            const SizedBox(height: 30),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [

                sessionCard(25, "⚡"),
                sessionCard(45, "🎯"),
                sessionCard(90, "🔥"),
                sessionCard(120, "👑"),

              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {},

                child: const Text(
                  "START SESSION",
                ),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  Widget sessionCard(int minutes, String emoji) {

    bool selected = selectedMinutes == minutes;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedMinutes = minutes;

        });

      },

      child: Container(

        width: 150,
        height: 90,

        decoration: BoxDecoration(

          color: selected
              ? AppColors.primary
              : Colors.grey.shade900,

          borderRadius: BorderRadius.circular(18),

        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),

            const SizedBox(height: 8),

            Text(
              "$minutes min",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}