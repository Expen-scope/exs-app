import 'dart:convert';
import 'package:http/http.dart' as http;

class FinancialModel {
  // جلب البيانات من الـ API (نفقات وإيرادات)
  Future<Map<String, dynamic>> fetchFinancialData() async {
    try {
      final response =
          await http.get(Uri.parse('https://your-api-url.com/financial-data'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // البيانات القادمة من الـ API
      } else {
        throw Exception('فشل تحميل البيانات');
      }
    } catch (e) {
      rethrow;
    }
  }
}
