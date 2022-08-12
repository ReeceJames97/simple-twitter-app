import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/posts_model.dart';
import 'package:simple_twitter_app/screens/posts/list_posts.dart';
import 'package:simple_twitter_app/services/posts_service.dart';

class Feed extends StatefulWidget {
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PostsService _postsService = PostsService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<PostsModel?>>.value(
      value: _postsService.getFeed(),
      initialData: [],
      child: const Scaffold(
        body: ListPosts(),
      ),
    );
  }
}
