import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/screens/home.dart';
import 'package:simple_twitter_app/screens/posts/add_tweet.dart';
import 'package:simple_twitter_app/screens/profile/edit.dart';
import 'package:simple_twitter_app/screens/profile/profile.dart';
import 'package:simple_twitter_app/screens/sign_up.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const SignUp();
    } else {
      //show main system routes
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/add': (context) => AddTweet(),
          '/profile': (context) => Profile(),
          '/edit': (context) => Edit(),
        },
      );
    }
  }
}
