import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/posts_model.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/screens/posts/list_posts.dart';
import 'package:simple_twitter_app/services/posts_service.dart';
import 'package:simple_twitter_app/services/user_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PostsService _postsService = PostsService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)?.settings.arguments as String;
    return MultiProvider(
        providers: [
          StreamProvider<bool>.value(
              value: _userService.isFollowing(
                  FirebaseAuth.instance.currentUser?.uid, uid),
              initialData: false),
          StreamProvider<List<PostsModel?>>.value(
              // StreamProvider.value(
              value: _postsService.getPosts(uid),
              initialData: const []),
          StreamProvider<UserModel?>.value(
              value: _userService.getUserInfo(uid), initialData: null),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 160,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                            Provider.of<UserModel?>(context)?.bannerImageUrl ??
                                '',
                            fit: BoxFit.cover, loadingBuilder:
                                (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                      return (loadingProgress != null)
                          ? Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(20),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : child;
                    }, errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                      return const Align(
                        alignment: Alignment.center,
                        // child: Text(STRINGS.processing)
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    })),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      // transform: Matrix4.translationValues(0.0, -20, 0.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Provider.of<UserModel?>(context)
                                              ?.profileImageUrl !=
                                          null &&
                                      Provider.of<UserModel?>(context)
                                              ?.profileImageUrl !=
                                          ''
                                  ? CircleAvatar(
                                      radius: 37,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                            Provider.of<UserModel?>(context)
                                                    ?.profileImageUrl ??
                                                ''),
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 37,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: AssetImage(
                                            'assets/images/profile_icon.png'),
                                      ),
                                    ),
                              if (FirebaseAuth.instance.currentUser?.uid == uid)
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit');
                                    },
                                    child: const Text(STRINGS.edit_profile))
                              else if (FirebaseAuth.instance.currentUser?.uid !=
                                      uid &&
                                  !Provider.of<bool>(context))
                                TextButton(
                                    onPressed: () {
                                      _userService.followUser(uid);
                                    },
                                    child: const Text(STRINGS.follow))
                              else if (FirebaseAuth.instance.currentUser?.uid !=
                                      uid &&
                                  Provider.of<bool>(context))
                                TextButton(
                                    onPressed: () {
                                      _userService.unfollowUser(uid);
                                    },
                                    child: const Text(STRINGS.unfollow)),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Text(
                                Provider.of<UserModel?>(context)?.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 1,
                            color: Colors.black38,
                          )
                        ],
                      ),
                    )
                  ]))
                ];
              },
              body: const ListPosts()),
        ));
  }
}
