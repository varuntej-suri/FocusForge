import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/focus_session_model.dart';
import '../services/token_service.dart';

class SessionApi {
  static const String baseUrl = "http://192.168.0.110:8000";

  static Future<bool> saveSession({
    required int duration,
    required bool completed,
  }) async {
    try {
      String? token = await TokenService.getToken();

      if (token == null) {
        return false;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/sessions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "duration": duration,
          "completed": completed,
        }),
      );

      print("Save Session Status: ${response.statusCode}");
      print("Save Session Response: ${response.body}");

      return response.statusCode == 200;

    } catch (e) {
      print("Save Session Error: $e");
      return false;
    }
  }
  static Future<List<FocusSession>> getSessions() async {
  try {
    String? token = await TokenService.getToken();

    if (token == null) {
      return [];
    }

    final response = await http.get(
      Uri.parse("$baseUrl/sessions"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("Get Sessions Status: ${response.statusCode}");
    print("Get Sessions Response: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => FocusSession.fromJson(e))
          .toList();
    }

    return [];
  } catch (e) {
    print("Get Sessions Error: $e");
    return [];
  }
}
}