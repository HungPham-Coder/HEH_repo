import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllowFunction {
  static Future CustomAlertDialog(BuildContext context, text, content) {
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
            'https://assets8.lottiefiles.com/packages/lf20_0P6TnSO6YK.json',
            repeat: false,
            height: 80,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.start,
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }
}
