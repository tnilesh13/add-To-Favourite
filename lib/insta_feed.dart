import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstagramFeed extends StatefulWidget {
  @override
  _InstagramFeedState createState() => _InstagramFeedState();
}

class _InstagramFeedState extends State<InstagramFeed> {
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchInstagramFeed();
  }

  Future<void> _fetchInstagramFeed() async {
    final response = await http.get(Uri.parse(
        'https://graph.instagram.com/me/media?fields=id,caption,media_type,media_url,thumbnail_url&access_token=IGQWRQQUVibEtRV201anJMSnh6VVp1SkZAXUGVXU2xtTTJWZADZAlem5ncEk0RU0yUG5pbzFkbGpRUHZASSDZARSVNxNkM1Mk5UcElpenBNTXNLSHdyOXVZAa0ZARUUtaZAnZA0WlRqZAExaaDF1bS1ab045M3hWUGtLYWdmX0UZD'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _posts = jsonData['data'];
      });
    } else {
      throw Exception('Failed to load Instagram feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            itemCount: _posts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2
            ),
            itemBuilder: (context, index) {
              final post = _posts[index];
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(post['media_type'] == 'IMAGE'
                            ? post['media_url']
                            : post['thumbnail_url']),fit: BoxFit.cover)),
                // Text(post['caption'] != null ? post['caption'] : ''),
                // onTap: () {
                // },
                child: Center(
                  child: post['media_type'] != 'IMAGE'
                      ? Icon(Icons.play_circle)
                      : null,
                ),
              );
            },
          );
  }
}
