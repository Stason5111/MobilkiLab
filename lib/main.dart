import 'package:flutter/material.dart';
import 'weather_repository.dart';
import 'weather_data.dart';

void main() => runApp(MyWeatherApp());

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погодное приложение',
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
  final WeatherRepository _weatherRepository = WeatherRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погодное приложение'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Введите город'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Получить погоду'),
            ),
            SizedBox(height: 20),
            FutureBuilder<WeatherData>(
              future: _weatherRepository.getWeather(_cityController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Состояние загрузки
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Состояние ошибки
                  return Text('Ошибка: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  // Состояние отсутствия данных
                  return Text('Данные о погоде отсутствуют.');
                } else {
                  // Данные успешно получены
                  WeatherData weatherData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Температура: ${weatherData.temperature}°C',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Описание: ${weatherData.description}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Image.network(
                        'https://openweathermap.org/img/w/${weatherData.icon}.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
