import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/superior.dart';

class SuperiorApi {
  static const String baseUrl = "http://localhost/api/superior";

  static Future<List<Superior>> getSuperiors() async {
    final response = await http.get(Uri.parse(baseUrl));

    final body = jsonDecode(response.body);
    final List data = body["data"];

    return data.map((e) => Superior.fromJson(e)).toList();
  }
}
