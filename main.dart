import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class News {
  final String title;
  final String description;

  News({
    required this.title,
    required this.description,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      description: json['description'],
    );
  }
}

class ApiService {
  Future<List<News>> fetchLatestNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2023-09-25&sortBy=publishedAt&apiKey=7c5958d843a243a59431104ec89fcbbc'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<News> news = data.map((e) => News.fromJson(e)).toList();
      return news;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Berita Terkini'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  List<News> news = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await apiService.fetchLatestNews();
      setState(() {
        news = result;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return news.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(news[index].title),
                subtitle: Text(news[index].description),
              );
            },
          );
  }
}
