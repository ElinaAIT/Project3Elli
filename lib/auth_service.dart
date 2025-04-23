// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String baseUrl = 'http://127.0.0.1:8000/api/auth';

//   // Регистрация
//   Future<Map<String, dynamic>> register(
//       String name, String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', data['access_token']);
//       return data;
//     } else {
//       throw Exception('Failed to register: ${response.body}');
//     }
//   }

//   // Авторизация
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', data['access_token']);
//       return data;
//     } else {
//       throw Exception('Failed to login: ${response.body}');
//     }
//   }

//   // Получение токена
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   // Выход
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//   }
// }
