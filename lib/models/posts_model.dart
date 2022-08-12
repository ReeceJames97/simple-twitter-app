import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel{
  final String? id;
  final String? creator;
  final String? text;
  final Timestamp? timestamp;
  // final String? originalId;
  // final bool? retweet;
  // int? likesCount;
  // int? retweetsCount;

  PostsModel({this.id, this.creator, this.text, this.timestamp,
    // this.likesCount,
    // this.retweetsCount,
    // this.originalId,
    // this.retweet,
  });
}