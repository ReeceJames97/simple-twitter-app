import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/services/utils_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class UserService {
  final UtilsService _utilsService = UtilsService();

  List<UserModel?> _userListFromFirebase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        id: doc.id,
        name: doc.get('name') ?? '',
        profileImageUrl: doc.get('profileImageUrl') ?? '',
        bannerImageUrl: doc.get('bannerImageUrl') ?? '',
        email: doc.get('email') ?? '',
      );
    }).toList();
  }

  UserModel? _userFromFirebase(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            name: snapshot.get('name') ?? '',
            profileImageUrl: snapshot.get('profileImageUrl') ?? '',
            bannerImageUrl: snapshot.get('bannerImageUrl') ?? '',
            email: snapshot.get('email') ?? '',
          )
        : null;
  }

  Stream<bool> isFollowing(uid, otherId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .doc(otherId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Stream<UserModel?> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebase);
  }

  Stream<List<UserModel?>> queryByName(search) {

    return FirebaseFirestore.instance
        .collection('users')
        .where('email',isNotEqualTo:FirebaseAuth.instance.currentUser?.email)
        .orderBy('email')
        .startAt([search])
    // .limit(10)
        .endAt([search + '\uf8ff'])
        .get()
        .asStream()
        .map(_userListFromFirebase);
  }

  // Stream<List<UserModel?>> getUserInfo(uid){
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .snapshots()
  //       .map(_userFromFirebase);
  // }

  // Future<bool> editPost()

  Future<bool> updateProfile(File _bannerImage, File _profileImage, String name) async {
    try{
      String bannerImageUrl = '';
      String profileImageUrl = '';

      bannerImageUrl = await _utilsService.uploadFile(_bannerImage,
          'user/profile/${FirebaseAuth.instance.currentUser?.uid}/banner');
      profileImageUrl = await _utilsService.uploadFile(_profileImage,
          'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');

      Map<String, Object> data = HashMap();
      if (name != '') data['name'] = name;
      if (bannerImageUrl != '') data['bannerImageUrl'] = bannerImageUrl;
      if (profileImageUrl != '') data['profileImageUrl'] = profileImageUrl;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(data);
      showToast(STRINGS.successful);
      return true;
    }catch(e){
      showToast(STRINGS.something_went_wrong);
      return false;
    }

  }

  Future<void> followUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('following')
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});
  }

  Future<void> unfollowUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('following')
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .delete();
  }

  Future<List<String>> getUserFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();

    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
  }
}
