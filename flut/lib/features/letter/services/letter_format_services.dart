import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter_format.dart';

class LetterFormatService {
  static const String baseUrl = "http://192.168.72.61:8000/api";

  static Future<List<LetterFormat>> fetchLetterFormats() async {
    final url = Uri.parse("$baseUrl/letter-formats");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data.map((e) => LetterFormat.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}
