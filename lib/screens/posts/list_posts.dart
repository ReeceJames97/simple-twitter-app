import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/posts_model.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/services/posts_service.dart';
import 'package:simple_twitter_app/services/user_service.dart';
import 'package:simple_twitter_app/utils/empty_view.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class ListPosts extends StatefulWidget {
  const ListPosts({Key? key}) : super(key: key);

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final UserService _userService = UserService();
  final PostsService _postsService = PostsService();

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostsModel?>>(context);

    return (posts.isNotEmpty)
        ? ListView.builder(
            itemCount: posts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final post = posts[index];

              return StreamBuilder(
                  stream: _userService.getUserInfo(post?.creator),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel?> snapshotUser) {
                    if (!snapshotUser.hasData) {
                      return Center(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20),
                          child: const CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }

                    return StreamBuilder(
                        stream: _postsService.getCurrentUserLike(post),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshotLike) {
                          if (!snapshotLike.hasData) {
                            return Center(
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(20),
                                child: const CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }
                          // else{
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                children: [
                                  snapshotUser.data?.profileImageUrl != ''
                                      ? CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              snapshotUser.data?.profileImageUrl ??
                                                  ''))
                                      : const Icon(
                                          Icons.person,
                                          size: 40,
                                        ),
                                  const SizedBox(width: 10),
                                  Text(
                                    snapshotUser.data?.name ?? STRINGS.user_name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),

                                ],
                              ),

                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(post?.text ??
                                          'This is tweet example.',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),),
                                      const SizedBox(height: 20),
                                      Text(
                                          post!.timestamp!.toDate().toString()),
                                      const SizedBox(height: 20),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [

                                          Row(children: [
                                            IconButton(
                                                onPressed: () {
                                                  _postsService.likePost(post, snapshotLike.data!);
                                                },
                                                icon: Icon(
                                                  snapshotLike.data! ?
                                                  Icons.favorite : Icons.favorite_border,
                                                  color: Colors.blue,
                                                  size: 28,
                                                )),
                                            // Text(post.likesCount.toString())
                                          ],),

                                          Row(
                                            children: [
                                              IconButton(
                                                // onPressed: () => _postsService.retweet(post, false),
                                                  onPressed: (){
                                                    showToast("Not available yet!");
                                                  },
                                                  icon: const Icon( Icons.chat_bubble_outline,
                                                    color: Colors.blue,
                                                    size: 28,
                                                  )),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              IconButton(
                                                  // onPressed: () => _postsService.retweet(post, false),
                                                  onPressed: (){
                                                    showToast("Not available yet!");
                                                  },
                                                  icon: const Icon(Icons.repeat,
                                                    color: Colors.blue,
                                                    size: 28,
                                                  )),
                                              // Text(post.likesCount.toString())
                                            ],
                                          ),

                                      ],),

                                    ],
                                  ),
                                ),
                                const Divider(thickness: 1),
                              ],
                            ),
                          );
                        });
                    // }
                  });
              // print("INDEX $index");
            })
        : getEmptryView(
            title: "No Feeds", message: "There is nothing to show you");
    // Container(
    //   alignment: Alignment.center,
    //   margin: const EdgeInsets.all(20),
    //   child: const CircularProgressIndicator(
    //     color: Colors.blue,
    //   ),
    // );
  }
}
