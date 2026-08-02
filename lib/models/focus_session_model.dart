class FocusSession {
  final int id;
  final int userId;
  final int duration;
  final bool completed;
  final String createdAt;

  FocusSession({
    required this.id,
    required this.userId,
    required this.duration,
    required this.completed,
    required this.createdAt,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json["id"],
      userId: json["user_id"],
      duration: json["duration"],
      completed: json["completed"],
      createdAt: json["created_at"],
    );
  }
}