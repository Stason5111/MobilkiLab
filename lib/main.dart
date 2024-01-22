import 'package:flutter/material.dart';
import 'weather_repository.dart';
import 'weather_data.dart';

void main() => runApp(MyWeatherApp());

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  WeatherData? _weatherData;
  final WeatherRepository _weatherRepository = WeatherRepository();

  Future<void> _getWeather() async {
    try {
      final String city = _cityController.text;
      final WeatherData weatherData = await _weatherRepository.getWeather(city);
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print('Error: $e');
      // Обработка ошибок
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter City'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _weatherData != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Temperature: ${_weatherData!.temperature}°C',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Description: ${_weatherData!.description}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Image.network(
                  'https://openweathermap.org/img/w/${_weatherData!.icon}.png',
                  width: 100,
                  height: 100,
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
