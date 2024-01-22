import 'package:flutter/material.dart';
import 'news_repository.dart';
import 'news_model.dart';

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
  late Future<List<News>> newsList;

  @override
  void initState() {
    super.initState();
    newsList = NewsRepository().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: FutureBuilder<List<News>>(
        future: newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<News> news = snapshot.data ?? [];
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final title = news[index].title;
                final description = news[index].description;

                return ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(news[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NewsDetail extends StatelessWidget {
  final News news;

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
              news.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(news.description),
            SizedBox(height: 16),
            Text(news.content),
          ],
        ),
      ),
    );
  }
}
