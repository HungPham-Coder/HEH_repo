import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/util/utilities.dart';
import 'package:heh_application/welcome.dart';

class NotificationService {
  Future<void> createTestNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(),
            channelKey: 'basic_channel',
            title:
                '${Emojis.emotion_blue_heart + Emojis.emotion_heart_decoration}',
            body: 'Test Notification',
            bigPicture:
                'https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome2.png?alt=media&token=e26f1d4f-e548-406c-aa71-65c099663f85',
            notificationLayout: NotificationLayout.BigPicture));
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Revieved');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      WelcomePage1.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => LandingPage(),
        ),
      );
    }
  }
}
