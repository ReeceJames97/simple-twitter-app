import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/screens/profile/list_users.dart';
import 'package:simple_twitter_app/services/user_service.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final UserService _userService = UserService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel?>>.value(
      value: _userService.queryByName(search),
      initialData: const [],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  search = text;
                });
              },
              decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const ListUsers(),
        ],
      ),
    );
  }
}
