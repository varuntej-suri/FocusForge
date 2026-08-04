import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../api/session_api.dart';
import '../../services/dnd_service.dart';
import '../../services/notification_service.dart';
import 'celebration_screen.dart';
import 'session_result_screen.dart';

class TimerScreen extends StatefulWidget {
  final int minutes;

  const TimerScreen({
    super.key,
    required this.minutes,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int totalSeconds;
  late int remainingSeconds;

  Timer? timer;

  bool isRunning = true;

  @override
  void initState() {
    super.initState();

    totalSeconds = widget.minutes * 60;
    remainingSeconds = totalSeconds;

    // Keep screen awake
    WakelockPlus.enable();

    // Request & Enable DND
    DndService.requestPermission();
    DndService.enableDnd();

    // Start timer
    startTimer();
  }
    // -----------------------------
  // Start Timer
  // -----------------------------
  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (remainingSeconds > 0) {
          if (!mounted) return;

          setState(() {
            remainingSeconds--;
          });

          return;
        }

        // Stop timer
        timer.cancel();

        // Disable wakelock
        await WakelockPlus.disable();

        // Disable DND
        await DndService.disableDnd();

        // Save session
        try {
          await SessionApi.saveSession(
            duration: widget.minutes,
            completed: true,
          );
        } catch (e) {
          // Ignore notification scheduling errors
        }

        // Show notification
        await NotificationService.showSessionCompletedNotification(
          widget.minutes,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CelebrationScreen(
              minutes: widget.minutes,
              totalSeconds: totalSeconds,
              focusedSeconds: totalSeconds,
            ),
          ),
        );
      },
    );

    setState(() {
      isRunning = true;
    });
  }
    // -----------------------------
  // Pause Timer
  // -----------------------------
  void pauseTimer() {
    timer?.cancel();

    if (!mounted) return;

    setState(() {
      isRunning = false;
    });
  }

  // -----------------------------
  // Resume Timer
  // -----------------------------
  void resumeTimer() {
    startTimer();
  }

  // -----------------------------
  // Skip Session
  // -----------------------------
  void showSkipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Skip Session?"),
        content: const Text(
          "Are you sure you want to skip this focus session?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Continue"),
          ),
          ElevatedButton(
  onPressed: () async {
    final navigator = Navigator.of(context);

    navigator.pop();

    timer?.cancel();

    await WakelockPlus.disable();
    await DndService.disableDnd();

    final focusedSeconds =
        totalSeconds - remainingSeconds;

    if (!mounted) return;

    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionResultScreen(
          minutes: widget.minutes,
          totalSeconds: totalSeconds,
          focusedSeconds: focusedSeconds,
          completed: false,
        ),
      ),
    );
  },
  child: const Text("Skip"),
),
        ],
      ),
    );
  }

  // -----------------------------
  // Format Timer
  // -----------------------------
  String formatTime() {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // -----------------------------
  // Dispose
  // -----------------------------
  @override
  void dispose() {
    timer?.cancel();

    WakelockPlus.disable();
    DndService.disableDnd();

    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalSeconds;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Focus Session"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              const Text(
                "Stay Focused 🔥",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Complete your session without distractions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Icon(
                          Icons.timer,
                          size: 40,
                          color: Colors.deepPurple,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          formatTime(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${widget.minutes} Minute Session",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isRunning) {
                          pauseTimer();
                        } else {
                          resumeTimer();
                        }
                      },
                      icon: Icon(
                        isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      label: Text(
                        isRunning
                            ? "Pause"
                            : "Resume",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
  child: ElevatedButton.icon(
    onPressed: () async {
      final navigator = Navigator.of(context);

      timer?.cancel();

      await WakelockPlus.disable();
      await DndService.disableDnd();

      if (!mounted) return;

      navigator.pop();
    },
    icon: const Icon(Icons.exit_to_app),
    label: const Text("Exit"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 55),
    ),
  ),
),

                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: showSkipDialog,
                  icon: const Icon(Icons.skip_next),
                  label: const Text("Skip Session"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}