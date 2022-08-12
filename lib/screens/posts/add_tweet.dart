import 'package:flutter/material.dart';
import 'package:simple_twitter_app/services/posts_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';

class AddTweet extends StatefulWidget {
  @override
  State<AddTweet> createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  final PostsService _postsService = PostsService();
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.tweet),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                _postsService.savePost(text);
                Navigator.pop(context);
              },
              child: const Text(STRINGS.tweet)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: STRINGS.what_is_happening,
          ),
          maxLines: 15,
          onChanged: (val) {
            setState(() {
              text = val;
            });
          },
        ),
      ),
    );
  }
}
