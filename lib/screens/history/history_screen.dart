import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/session_api.dart';
import '../../models/focus_session_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  List<FocusSession> sessions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {

    final data = await SessionApi.getSessions();

    data.sort(
      (a, b) => DateTime.parse(b.createdAt)
          .compareTo(DateTime.parse(a.createdAt)),
    );

    if (!mounted) return;

    setState(() {
      sessions = data;
      isLoading = false;
    });
  }
  int getTotalMinutes() {
    int total = 0;

    for (var session in sessions) {
      if (session.completed) {
        total += session.duration;
      }
    }

    return total;
  }

  String formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours == 0) {
      return "$mins min";
    }

    return "${hours}h ${mins}m";
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Session History"),
        centerTitle: true,
      ),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : sessions.isEmpty

              ? const Center(
                  child: Text(
                    "No Sessions Yet 🚀",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )

              : RefreshIndicator(

                  onRefresh: loadSessions,

                  child: ListView(

                    padding: const EdgeInsets.all(15),

                    children: [

                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "📊 Focus Summary",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              "⏱ Total Focus : ${formatMinutes(getTotalMinutes())}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "✅ Sessions : ${sessions.length}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ...sessions.map((session) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                            ),

                            title: Text(
                              "⏱ ${session.duration} Minutes",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SizedBox(height: 5),

                                Text(
                                  session.completed
                                      ? "Completed ✅"
                                      : "Skipped ❌",
                                  style: TextStyle(
                                    color: session.completed
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  DateFormat("dd MMM yyyy • hh:mm a")
                                      .format(DateTime.parse(session.createdAt)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                    ],
                  ),
                ),
    );
  }
}