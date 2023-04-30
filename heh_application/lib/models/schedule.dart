import 'package:heh_application/models/slot.dart';
import 'package:heh_application/models/type_of_slot.dart';
import 'physiotherapist.dart';

class Schedule {
  String? scheduleID;
  String slotID;
  Slot? slot;
  String physiotherapistID;
  Physiotherapist? physiotherapist;
  String? typeOfSlotID;
  TypeOfSlot? typeOfSlot;
  String? description;
  bool _physioBookingStatus;

  bool get physioBookingStatus => _physioBookingStatus;

  set physioBookingStatus(bool value) {
    _physioBookingStatus = value;
  }

  Schedule({
    this.scheduleID,
    required this.slotID,
    this.slot,
    required this.physiotherapistID,
    this.physiotherapist,
    this.typeOfSlotID,
    this.typeOfSlot,
    this.description,
    required bool physioBookingStatus,
  }) : _physioBookingStatus = physioBookingStatus;
  factory Schedule.fromMap(Map<String, dynamic> json) {
    if (json['slot'] == null &&
        json['physiotherapistDetail'] == null &&
        json['typeOfSlot'] == null&&
        json['typeOfSlotID'] == null) {
      return Schedule(
        scheduleID: json['scheduleID'],
        slotID: json['slotID'],
        physiotherapistID: json['physiotherapistID'],
        description: json['description'],
        physioBookingStatus: json['physioBookingStatus'],
      );
    } else {
      return Schedule(
        scheduleID: json['scheduleID'],
        slotID: json['slotID'],
        slot: Slot.fromMap(json['slot']),
        physiotherapistID: json['physiotherapistID'],
        physiotherapist: Physiotherapist.fromMap(json['physiotherapistDetail']),
        typeOfSlotID: json['typeOfSlotID'],
        typeOfSlot: TypeOfSlot.fromMap(json['typeOfSlot']),
        description: json['description'],
        physioBookingStatus: json['physioBookingStatus'],
      );
    }
  }
}
