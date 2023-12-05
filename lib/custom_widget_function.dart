import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomWidgetFunction {
  static Future loadingIndicatorDialoge(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(15.0),
        backgroundColor: Colors.white,
        content: Row(
          children: [
            Lottie.asset(
              "anim/loading.json",
              filterQuality: FilterQuality.high,
              height: 50.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Please wait..."),
            )
          ],
        ),
      ),
    );
  }

  static snackBar(String str, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 1750),
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        // width: 250.0,
        margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        content: Text(str, style: const TextStyle(color: Colors.black))));
  }
}
