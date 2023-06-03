import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllowFunction {
  static Future CustomAlertDialog(BuildContext context, text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Center(
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
          icon: Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_dygofb4l.json',
            repeat: false,
            height: 80,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content:  Text(
           text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
