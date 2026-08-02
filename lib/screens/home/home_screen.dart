import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/session_card.dart';
import '../timer/timer_screen.dart';
import '../../services/token_service.dart';
import '../../api/auth_api.dart';
import '../../models/user_model.dart';

import '../../models/focus_session_model.dart';
import '../../api/session_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String formatMinutes(int minutes) {

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours == 0) {
      return "$mins min";
    }

    return "${hours}h ${mins}m";
  }


  int selectedDuration = 90;
  int customDuration = 0;
  UserModel? user;
  List<FocusSession> sessions = [];

  int totalMinutes = 0;
  int totalSessions = 0;
  bool isLoadingProfile = true;
//   String formatMinutes(int minutes) {

//   final hours = minutes ~/ 60;
//   final mins = minutes % 60;

//   if (hours == 0) {
//     return "$mins min";
//   }

//   return "${hours}h ${mins}m";
// }

  final TextEditingController customController =
      TextEditingController();

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
      isLoadingProfile = false;
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
  print("Dashboard Sessions: ${data.length}");
  print("Dashboard Minutes: $minutes");
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
            icon: const Icon(Icons.logout),

            onPressed: () async {

              await TokenService.removeToken();

              if (!mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
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
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                user == null
                    ? "${getGreeting()} ${getGreetingEmoji()}"
                    : "${getGreeting()}, ${user!.name} ${getGreetingEmoji()}",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 4),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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

                  // const SizedBox(height: 10),
                  
                  const SizedBox(height: 4),

                  const Text(
                    "Today's Progress",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  const SizedBox(height: 6),

                  Text(
                    "Choose your focus session",
                    style: AppTextStyles.body,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView(
                  children: [

                    SessionCard(
                      title: "⚡ Quick Focus",
                      duration: "25 Minutes",
                      description:
                          "Perfect for short tasks",
                      isSelected:
                          selectedDuration == 25,
                      onTap: () {
                        setState(() {
                          selectedDuration = 25;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🚀 Deep Work",
                      duration: "45 Minutes",
                      description:
                          "Stay productive",
                      isSelected:
                          selectedDuration == 45,
                      onTap: () {
                        setState(() {
                          selectedDuration = 45;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🔥 Ultra Focus",
                      duration: "90 Minutes",
                      description:
                          "Maximum concentration",
                      isSelected:
                          selectedDuration == 90,
                      onTap: () {
                        setState(() {
                          selectedDuration = 90;
                        });
                      },
                    ),

                    SessionCard(
                      title: "🧠 Marathon",
                      duration: "120 Minutes",
                      description:
                          "Long uninterrupted work",
                      isSelected:
                          selectedDuration == 120,
                      onTap: () {
                        setState(() {
                          selectedDuration = 120;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed:
                            showCustomTimerDialog,
                        icon: const Icon(
                          Icons.timer,
                        ),
                        label: const Text(
                          "Customize Timer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TimerScreen(
                          minutes:
                              selectedDuration,
                        ),
                      ),
                    );
                  },

                  child: Text(
                    "START $selectedDuration MIN SESSION",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
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
                    Navigator.pushNamed(context, "/history");
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

  // Premium dialog will come in Part 2
  void showCustomTimerDialog() {
  customDuration = 0;
  customController.clear();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.timer_rounded,
                    color: Colors.deepPurple,
                    size: 50,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Customize Timer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Choose your focus duration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      GestureDetector(
                        onTap: () {
                          if (customDuration > 0) {
                            setDialogState(() {
                              customDuration--;

                              customController.text =
                                  customDuration == 0
                                      ? ""
                                      : customDuration.toString();

                              customController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: customController.text.length,
                                ),
                              );
                            });
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade800,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: customController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: getDurationColor(),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setDialogState(() {
                              customDuration =
                                  int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if (customDuration < 300) {
                            setDialogState(() {
                              customDuration++;

                              customController.text =
                                  customDuration.toString();

                              customController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: customController.text.length,
                                ),
                              );
                            });
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "1 - 300 Minutes",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [

                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white30,
                            ),
                            minimumSize:
                                const Size.fromHeight(52),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.deepPurple,
                            minimumSize:
                                const Size.fromHeight(52),
                          ),
                          onPressed: () {

                            final value =
                                int.tryParse(
                              customController.text,
                            );

                            if (value == null ||
                                value <= 0 ||
                                value > 300) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter 1 - 300 minutes",
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              selectedDuration = value;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Start",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}