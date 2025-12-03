import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseURL = "http://localhost:8000/api";

  static Future<bool> createSurat(Map data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseURL/letters"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      print('Create Letter Status: ${res.statusCode}');
      print('Create Letter Response: ${res.body}');
      
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print('Create Letter Exception: $e');
      return false;
    }
  }

  static Future<List> getSurat() async {
    try {
      final res = await http.get(Uri.parse("$baseURL/letters"));

      if (res.statusCode == 200) {
        final decode = jsonDecode(res.body);

        if (decode is Map && decode.containsKey('data')) {
          return decode['data'];
        }

        if (decode is List) {
          return decode;
        }
      }
      return [];
    } catch (e) {
      print('Get Letters Exception: $e');
      return [];
    }
  }

  static Future<bool> updateStatus(dynamic id, String status) async {
    try {
      final res = await http.put(
        Uri.parse("$baseURL/letters/$id/status"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"status": status}),
      );
      
      print('Update Status: ${res.statusCode}');
      print('Update Response: ${res.body}');
      
      return res.statusCode == 200;
    } catch (e) {
      print('Update Status Exception: $e');
      return false;
    }
  }
}
