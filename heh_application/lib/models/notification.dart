import 'package:heh_application/models/sign_up_user.dart';

class NotificationModel {
  String notifyID;
  String userID;
  SignUpUser? signUpUser;
  bool seen;
  String action;
  String description;
  String subject;
  String content;
  NotificationModel(
      {required this.notifyID,
        required this.userID,
      this.signUpUser,
      required this.seen,
      required this.action,
      required this.description,
      required this.subject,
      required this.content});

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    return NotificationModel(
        userID: json["userId"],
        notifyID: json['id'],
        seen: json["seen"],
        action: json["action"],
        description: json["description"],
        subject: json["subject"],
        content: json['content']
    );
  }
}
