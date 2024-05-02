import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class MusicNewsPage extends StatefulWidget {
  @override
  State<MusicNewsPage> createState() => _MusicNewsPageState();
}

class _MusicNewsPageState extends State<MusicNewsPage> {
  List<NewsArticle> _newsArticles = [];
  int _displayedArticles = 10;
  final int _increment = 10;

  @override
  void initState() {
    super.initState();
    fetchNews().then((news) {
      setState(() {
        _newsArticles = news;
      });
    });
  }

  Future<void> _loadMoreNews() async {
    final moreNews = await fetchNews();
    setState(() {
      _newsArticles.addAll(moreNews);
      _displayedArticles += _increment;
    });
  }

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=music&apiKey=45ec4467a4f1498fa4c009b4b3b45391'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = _displayedArticles > _newsArticles.length
        ? _newsArticles.length
        : _displayedArticles;

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade500,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              height: 40.0,
              margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              alignment: Alignment.center,
              child: Text(
                "Music News",
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itemCount + 1,
                itemBuilder: (context, index) {
                  if (index == itemCount) {
                    return ListTile(
                      title: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.blueGrey.shade300,
                          ),
                        ),
                        onPressed: _loadMoreNews,
                        child: Text("Show More"),
                      ),
                    );
                  } else {
                    final article = _newsArticles[index];
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(article.imageUrl),
                        ),
                        title: Text(
                          article.title.length > 50
                              ? article.title.substring(0, 50) + '...'
                              : article.title,
                        ),
                        subtitle: Text(
                          article.description.length > 100
                              ? article.description.substring(0, 100) + '...'
                              : article.description,
                        ),
                        onTap: () async {
                          final url = Uri.parse(article.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print('Could not launch $url');
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
    );
  }
}
