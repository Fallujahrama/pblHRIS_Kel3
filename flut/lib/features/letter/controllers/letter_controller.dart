import 'package:dio/dio.dart';
import '../services/letter_format_services.dart';
import '../models/letter_format.dart';

class LetterController {
  final dio = Dio(BaseOptions(baseUrl: "http://127.0.0.1:8000"));

  Future<Response> createLetter(Map<String, dynamic> data) async {
    return await dio.post('/api/letters', data: data);
  }

  Future<List<LetterFormat>> fetchLetterFormats() async {
    try {
      return await LetterFormatService.fetchLetterFormats();
    } catch (e) {
      print('Error fetching formats: $e');
      return [];
    }
  }

  String pdfUrl(int id) {
    return "http://127.0.0.1:8000/letters/$id/pdf";
  }
}
