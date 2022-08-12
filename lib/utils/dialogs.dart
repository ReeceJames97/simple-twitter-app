import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_twitter_app/utils/strings.dart';

AlertDialog? mAlertDialog;

void showLoading(BuildContext context) {
  showProgressDialog(context, STRINGS.processing);
}

Future<void> showProgressDialog(BuildContext context, String title) async {
  try {
    if (mAlertDialog == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            mAlertDialog = AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  // CircularProgressIndicator(),

                  Container(
                    width: 30,
                    height: 30,
                    child: Lottie.asset('assets/images/loadingspinner.json',
                        width: 30,
                        height: 30,
                        animate: true,
                        repeat: true,
                        fit: BoxFit.fill),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
            return WillPopScope(
                child: mAlertDialog!,
                onWillPop: () {
                  hideDialog(context);
                  return Future.value(true);
                });
          });
    } else {
      print("alert is not null");
    }
  } catch (e) {
    print(e.toString());
  }
}

void hideDialog(BuildContext context) {
  if (mAlertDialog != null) {
    mAlertDialog = null;
    Navigator.of(context).pop();
  }
}

Future<bool> hideDialogAsyn(BuildContext context) async {
  if (mAlertDialog != null) {
    mAlertDialog = null;
    Navigator.of(context).pop();
  }
  return Future.value(true);
}
