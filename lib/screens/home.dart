import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_twitter_app/screens/home/feed.dart';
import 'package:simple_twitter_app/screens/home/search.dart';
import 'package:simple_twitter_app/services/auth_service.dart';
import 'package:simple_twitter_app/utils/dialogs.dart';
import 'package:simple_twitter_app/utils/strings.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();
  int currentIndex = 0;

  List<Widget> btmNavBarItems = [Feed(), Search()];

  void onTapPressed(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    hideDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(STRINGS.home),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
            elevation: 10,
            child: Image.asset('assets/images/new_tweet.png')),
        drawer: Drawer(
            child: ListView(
                children: [
            DrawerHeader(
            decoration: const BoxDecoration(color: Colors.lightBlueAccent),
            child: Center(
              child: Column(
                children: [

                  ///Lottie
                  Container(
                    child: Lottie.asset('assets/images/twitter.json',
                        width: 100,
                        height: 100,
                        animate: true,
                        repeat: true,
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    STRINGS.twitter,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            )),
        ListTile(
          title: const Text(STRINGS.profile),
          // trailing: const Icon(Icons.person),
          onTap: () {
            Navigator.pushNamed(context, '/profile',
                arguments: FirebaseAuth.instance.currentUser?.uid);
          },
        ),
        // ListTile(
        //   title: const Text(STRINGS.setting),
        //   // trailing: const Icon(Icons.settings),
        //   onTap: (){
        //     Navigator.pushNamed(context, '/setting');
        //   },
        // ),
        // ListTile(
        //   title: const Text(STRINGS.about),
        //   // trailing: const Icon(Icons.info),
        //   onTap: (){
        //     Navigator.pushNamed(context, '/about');
        //   },
        // ),
        ListTile(
        title: const Text(STRINGS.logout),
    // trailing: const Icon(Icons.logout),
    onTap: () async {
    showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?"),
    actions: <Widget>[
    TextButton(
    onPressed: () {
    Navigator.of(ctx).pop();
    },

    child: const Text("Cancel"),
    ),
    TextButton(
    onPressed: () {
    authService
        .
    signOut
    (
    );
    Navigator.of(ctx).pop();
    },

    child: const Text("OK"),

    ),
    ],
    ),
    );
    },

  )

  ,

  ]

  ,

  )

  ,

  )

  ,

  bottomNavigationBar

      :

  BottomNavigationBar

  (

  onTap

      :

  onTapPressed

  ,

  currentIndex

      :

  currentIndex

  ,

  showUnselectedLabels

      :

  false

  ,

  items

      :

  const

  [

  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search')
  ],
  ),
  body: btmNavBarItems

  [

  currentIndex

  ]

  ,

  );
}}
