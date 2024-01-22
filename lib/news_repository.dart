import 'package:http/http.dart' as http;
import 'dart:convert';

import 'news_model.dart';


class NewsRepository {
  Future<List<News>> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=7095f12df4cc43658775cb9c270e8bd2'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> articles = List<Map<String, dynamic>>.from(data['articles'] ?? []);
        return articles.map((article) => News.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
