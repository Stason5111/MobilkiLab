import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _celsiusController = TextEditingController();
  TextEditingController _fahrenheitController = TextEditingController();

  void _convertTemperature() {
    double celsius = double.tryParse(_celsiusController.text) ?? 0.0;
    double fahrenheit = (celsius * 9 / 5) + 32;
    _fahrenheitController.text = fahrenheit.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _celsiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Celsius'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert to Fahrenheit'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _fahrenheitController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Equivalent Fahrenheit'),
            ),
          ],
        ),
      ),
    );
  }
}