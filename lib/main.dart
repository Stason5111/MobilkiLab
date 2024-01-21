import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: NewsList(),
    );
  }
}

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<Map<String, dynamic>> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=7095f12df4cc43658775cb9c270e8bd2'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          newsList = List<Map<String, dynamic>>.from(data['articles'] ?? []);
        });
      } else {
        print('Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final title = newsList[index]['title'] ?? 'No Title';
          final description = newsList[index]['description'] ?? 'No Description';

          return ListTile(
            title: Text(title),
            subtitle: Text(description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(newsList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NewsDetail extends StatelessWidget {
  final Map<String, dynamic> news;

  NewsDetail(this.news);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(news['description'] ?? 'No Description'),
            SizedBox(height: 16),
            Text(news['content'] ?? 'No Content'),
          ],
        ),
      ),
    );
  }
}