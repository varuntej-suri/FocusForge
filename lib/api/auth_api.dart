import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../services/token_service.dart';

class AuthApi {
  static const String baseUrl = "http://192.168.0.110:8000";
    static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/register"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
      }

      return {
        "success": false,
        "message": jsonDecode(response.body)["detail"],
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
    static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/login"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 5));


      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
      }

      return {
        "success": false,
        "message": jsonDecode(response.body)["detail"],
      };
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
    static Future<UserModel?> getProfile() async {
    try {
      String? token = await TokenService.getToken();

      if (token == null) return null;

      final response = await http
          .get(
            Uri.parse("$baseUrl/profile"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          )
          .timeout(const Duration(seconds: 5));


      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}