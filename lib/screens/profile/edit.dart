import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_twitter_app/services/user_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';

class Edit extends StatefulWidget {
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final UserService _userService = UserService();
  File? _profileImage;
  File? _bannerImage;
  final picker = ImagePicker();
  String name = '';
  String userName = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future getImageFromCamera(int type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null && type == 0) {
        _profileImage = File(pickedFile.path);
      }
      if (pickedFile != null && type == 1) {
        _bannerImage = File(pickedFile.path);
      }
    });
  }

  Future getImageFromGallery(int type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null && type == 0) {
        _profileImage = File(pickedFile.path);
      }
      if (pickedFile != null && type == 1) {
        _bannerImage = File(pickedFile.path);
      }
    });
  }

  displayCoverImage() {
    if (_bannerImage == null) {
      return const AssetImage('assets/images/ice_landscape.jpg');
      // return null;
    } else {
      return FileImage(_bannerImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      return const AssetImage('assets/images/profile_icon.png');
    } else {
      return FileImage(_profileImage!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                STRINGS.choose_image_source,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // const Divider(thickness: 2,),
                              Row(
                                children: [
                                  const Icon(Icons.camera_alt),
                                  TextButton(
                                      onPressed: () {
                                        getImageFromCamera(1);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(STRINGS.camera)),
                                ],
                              ),

                              const Divider(
                                thickness: 1,
                              ),

                              Row(
                                children: [
                                  const Icon(Icons.photo),
                                  TextButton(
                                      onPressed: () {
                                        getImageFromGallery(1);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(STRINGS.gallery)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      image: _bannerImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover, image: displayCoverImage())),
                ),
                Container(
                  height: 150,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: SizedBox(
                                  height: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          STRINGS.choose_image_source,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // const Divider(thickness: 2,),
                                        Row(
                                          children: [
                                            const Icon(Icons.camera_alt),
                                            TextButton(
                                                onPressed: () {
                                                  getImageFromCamera(0);
                                                  Navigator.of(context).pop();
                                                },
                                                child:
                                                    const Text(STRINGS.camera)),
                                          ],
                                        ),

                                        const Divider(
                                          thickness: 1,
                                        ),

                                        Row(
                                          children: [
                                            const Icon(Icons.photo),
                                            TextButton(
                                                onPressed: () {
                                                  getImageFromGallery(0);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                    STRINGS.gallery)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Stack(children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: displayProfileImage(),
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              Icon(Icons.camera_alt,
                                  size: 25, color: Colors.white)
                            ],
                          ),
                        )
                      ]),
                    ),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          bool isSuccessful = await _userService.updateProfile(
                              _bannerImage!, _profileImage!, name);
                          if (!isSuccessful) {
                            setState(() {
                              isLoading = isSuccessful;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(STRINGS.save))
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          enabled: !isLoading,
                          initialValue: name,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          validator: (input) => input!.trim().length < 2
                              ? 'please enter valid name'
                              : null,
                          onChanged: (value) {
                            name = value;
                          },
                        )
                      ],
                    )),
                isLoading
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(20),
                        child: const CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
