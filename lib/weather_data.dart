class WeatherData {
  final double temperature;
  final String description;
  final String icon;

  const WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    return WeatherData(
      temperature: main['temp'].toDouble() - 273.15,
      description: weather['description'],
      icon: weather['icon'],
    );
  }
}
