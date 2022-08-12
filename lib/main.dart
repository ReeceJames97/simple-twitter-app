import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/screens/wrapper.dart';
import 'package:simple_twitter_app/services/auth_service.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          //Check for error
          if (snapshot.hasError) {
            showToast(STRINGS.something_went_wrong);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<UserModel?>.value(
              value: AuthService().user,
              initialData: AuthService().initilaUser,
              child: const MaterialApp(
                  debugShowCheckedModeBanner: false, home: Wrapper()),
              // home: Splash()),
            );
          }

          return const Directionality(
              textDirection: TextDirection.ltr,
              child: SpinKitFadingCircle(
                duration: Duration(seconds: 2),
                size: 100,
                color: Colors.black12,
              ));
        });
  }
}
