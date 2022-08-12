import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/iterables.dart';
import 'package:simple_twitter_app/models/posts_model.dart';
import 'package:simple_twitter_app/services/user_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class PostsService {
  List<PostsModel> _postsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostsModel(
        id: doc.id,
        text: doc.get("text") ?? '',
        creator: doc.get("creator") ?? '',
        timestamp: doc.get("timestamp") ?? 0,
        // likesCount: doc.get("likesCount") ?? 0,
        // retweetsCount: doc.get("retweetsCount") ?? 0,
        // retweet: doc.get("retweet") ?? false,
        // originalId: doc.get("originalId") ?? null,
      );
    }).toList();
  }

  // PostsModel? _postFromSnapshot(DocumentSnapshot snapshot) {
  //   return snapshot.exists
  //       ? PostsModel(
  //           id: snapshot.id,
  //           text: snapshot.get('text') ?? '',
  //           creator: snapshot.get('creator') ?? '',
  //           timestamp: snapshot.get('timestamp') ?? 0,
  //           // likesCount: snapshot.get('likesCount') ?? 0,
  //           // retweetsCount: snapshot.get('retweetsCount') ?? 0,
  //           // retweet: snapshot.get('retweet') ?? false,
  //           // originalId: snapshot.get('originalId') ?? null,
  //           // ref: snapshot.reference,
  //         )
  //       : null;
  // }

  Future<bool> savePost(String text) async {
    try{
      await FirebaseFirestore.instance.collection("posts").add({
        'text': text,
        'creator': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp()
      });
      showToast(STRINGS.successful);
      return true;
    }catch(e){
      showToast(STRINGS.something_went_wrong);
      return false;
    }

  }

  Future deletePost(PostsModel post) async {
    await FirebaseFirestore.instance.collection("posts").doc(post.id).delete();
  }

  Future editPost(PostsModel post,String text) async {
    Map<String, Object> data = HashMap();
    if(text != '') data['text'] = text;
    await FirebaseFirestore.instance.collection('posts').doc(post.id).update(data);
  }

  Future likePost(PostsModel post, bool current) async {
    if (current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }

    if (!current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});
    }
  }

  // Future retweet(PostsModel postsModel, bool current) async {
  //   if(current){
  //     // postsModel.retweetsCount = postsModel.retweetsCount! - 1;
  //     await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(postsModel.id)
  //         .collection('retweets')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .delete();
  //
  //     await FirebaseFirestore.instance
  //         .collection('posts')
  //     .where('originalId' , isEqualTo: postsModel.id)
  //     .where('creator' , isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //     .get().then((value) {
  //       if(value.docs.length == 0){
  //         return;
  //       }
  //       FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(value.docs[0].id)
  //       .delete();
  //     });
  //     return;
  //   }
  //
  //   // postsModel.retweetsCount = postsModel.retweetsCount! + 1;
  //   await FirebaseFirestore.instance
  //   .collection('posts')
  //   .doc(postsModel.id)
  //   .collection('retweets')
  //   .doc(FirebaseAuth.instance.currentUser?.uid)
  //   .set({});
  //
  //   await FirebaseFirestore.instance
  //       .collection('posts').add({
  //     'creator' : FirebaseAuth.instance.currentUser?.uid,
  //     'timestamp' : FieldValue.serverTimestamp(),
  //     'retweet' : true,
  //     'originalId' : postsModel.id
  //   });
  //   }

  Stream<bool> getCurrentUserLike(PostsModel? post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post?.id)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Stream<List<PostsModel>> getPosts(uid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postsList);
  }

  // Future<PostsModel> getPostById(String id) async {
  //   DocumentSnapshot postSnap =
  //   await FirebaseFirestore.instance.collection("posts").doc(id).get();
  //
  //   return _postFromSnapshot(postSnap);
  // }

  Future<List<PostsModel?>> getFeed() async {
    List<String> usersFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser?.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<PostsModel> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postsList(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate!.compareTo(adate!);
    });

    return feedList;
  }
}
