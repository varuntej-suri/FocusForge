import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'session_result_screen.dart';

class CelebrationScreen extends StatefulWidget {
  final int minutes;
  final int totalSeconds;
  final int focusedSeconds;

  const CelebrationScreen({
    super.key,
    required this.minutes,
    required this.totalSeconds,
    required this.focusedSeconds,
  });

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen>
    with SingleTickerProviderStateMixin {

  late ConfettiController confettiController;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );

    animationController.forward();

    confettiController.play();

    playSound();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SessionResultScreen(
              minutes: widget.minutes,
              totalSeconds: widget.totalSeconds,
              focusedSeconds: widget.focusedSeconds,
              completed: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> playSound() async {
  await player.setVolume(0.3); // 30% volume
  await player.play(
    AssetSource("audio/cheer.mp3"),
  );

  Future.delayed(const Duration(seconds: 2), () {
    player.stop();
  });
}

  @override
  void dispose() {
    player.dispose();
    confettiController.dispose();
    animationController.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: Stack(
        children: [

          // Left Confetti
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: 0.5,
              emissionFrequency: 0.03,
              numberOfParticles: 15,
              gravity: 0.25,
              shouldLoop: false,
            ),
          ),

          // Right Confetti
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: 2.6,
              emissionFrequency: 0.03,
              numberOfParticles: 15,
              gravity: 0.25,
              shouldLoop: false,
            ),
          ),

          SafeArea(
            child: Center(
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 120,
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Congratulations!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "You completed your\nFocus Session",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withValues(alpha:0.45),
                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(
                              Icons.workspace_premium,
                              color: Colors.amber,
                              size: 34,
                            ),

                            SizedBox(width: 12),

                            Text(
                              "+25 XP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "🔥 Keep Going!",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Small progress every day\nleads to big success.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}