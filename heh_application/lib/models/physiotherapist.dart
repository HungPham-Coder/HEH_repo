import 'package:heh_application/models/sign_up_user.dart';

class PhysiotherapistModel {
  String physiotherapistID;
  String? skill;
  String? specialize;
  String? userID;
  SignUpUser? signUpUser;
  int scheduleStatus;

  PhysiotherapistModel(
      {required this.physiotherapistID,
      this.skill,
      this.specialize,
      required this.scheduleStatus,
      this.userID,
      this.signUpUser});
  factory PhysiotherapistModel.fromMap(Map<String, dynamic> json) {
    if (json['user'] == null) {
      return PhysiotherapistModel(
          physiotherapistID: json['physiotherapistID'],
          scheduleStatus: json['scheduleStatus'],
          skill: json['skill'],
          specialize: json['specialize']);
    } else {
      return PhysiotherapistModel(
          physiotherapistID: json['physiotherapistID'],
          userID: json['userID'],
          signUpUser: SignUpUser.fromMap(json['user'], ''),
          scheduleStatus: json['scheduleStatus'],
          skill: json['skill'],
          specialize: json['specialize']);
    }
  }
}
