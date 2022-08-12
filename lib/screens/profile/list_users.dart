import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/user_model.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel?>>(context);

    return (users.isNotEmpty)
        ? ListView.builder(
            itemCount: users.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final user = users[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: user?.id);
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          user?.profileImageUrl != ''
                              ? CircleAvatar(
                                  radius: 28,
                                  backgroundImage:
                                      NetworkImage(user?.profileImageUrl ?? ''),
                                )
                              : const CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(
                                      'assets/images/profile_icon.png'),
                                ),
                          const SizedBox(width: 10),
                          Text(
                            user?.name ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ]),
                      ),
                      // const Divider(
                      //   thickness: 1,
                      // ),
                    ],
                  ),
                ),
              );
            })
        : Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
  }
}
