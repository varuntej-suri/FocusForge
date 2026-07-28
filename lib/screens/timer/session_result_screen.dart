import 'package:flutter/material.dart';
import 'timer_screen.dart';

class SessionResultScreen extends StatelessWidget {
  final int minutes;
  final int totalSeconds;
  final int focusedSeconds;
  final bool completed;

  const SessionResultScreen({
    super.key,
    required this.minutes,
    required this.totalSeconds,
    required this.focusedSeconds,
    required this.completed,
  });

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final remainingSeconds = totalSeconds - focusedSeconds;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Session Result"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Icon(
              completed ? Icons.emoji_events : Icons.skip_next,
              color: completed ? Colors.green : Colors.orange,
              size: 90,
            ),

            const SizedBox(height: 20),

            Text(
              completed
                  ? "Congratulations!"
                  : "Session Skipped",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            buildInfoCard(
              "⏱ Session Duration",
              "$minutes Minutes",
            ),

            const SizedBox(height: 15),

            buildInfoCard(
              "🔥 Focused Time",
              formatTime(focusedSeconds),
            ),

            const SizedBox(height: 15),

            buildInfoCard(
              "⌛ Remaining",
              formatTime(remainingSeconds),
            ),

            const SizedBox(height: 15),

            buildInfoCard(
              "Status",
              completed ? "✅ Completed" : "❌ Skipped",
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text(
                  "Start Again",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TimerScreen(
                        minutes: minutes,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text(
                  "Home",
                  style: TextStyle(fontSize: 18),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}