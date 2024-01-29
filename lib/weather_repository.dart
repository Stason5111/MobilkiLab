import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_data.dart';

class WeatherRepository {
  static const String apiKey = '5433f6e50fbce585bc66862ed113f315';

  Future<WeatherData> getWeather(String city) async {
    try {
      final Uri uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
