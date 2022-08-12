import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_twitter_app/utils/colors.dart';
import 'package:simple_twitter_app/utils/strings.dart';

Widget getEmptryView({String? message, String? title, bool isAnimate = true}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const SizedBox(
        height: 40,
      ),
      (isAnimate != null && isAnimate)
          ? Container(
              child: Lottie.asset('assets/images/empty-box.json',
                  width: 100,
                  height: 100,
                  animate: true,
                  repeat: true,
                  fit: BoxFit.fill),
            )
          : SvgPicture.asset(
              "assets/images/ic_empty.svg",
              matchTextDirection: true,
              width: 120,
              height: 120,
            ),
      const SizedBox(
        height: 40,
      ),
      Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              (title != null && title.isNotEmpty) ? title : STRINGS.empty_data,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: COLORS.menu_color),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              (message == null || message == "")
                  ? STRINGS.nothing_to_show
                  : message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: COLORS.menu_color),
            )
          ],
        ),
      ),
    ],
  );
  // }
}
