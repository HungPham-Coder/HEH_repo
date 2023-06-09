import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_Schedule.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/error_model.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/exercise_model/exercise.dart';
import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/models/login_user.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/notification.dart';
import 'package:heh_application/models/payment.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/models/relationship.dart';
import 'package:heh_application/models/result_login.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/models/slot.dart';
import 'package:heh_application/models/slot.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/models/type_of_slot.dart';
import 'package:heh_application/models/favorite_exercise.dart';
import 'package:http/http.dart' as http;

import '../models/feedback.dart';
import '../models/problem.dart';
import '../models/role.dart';

class CallAPI {
  String link = 'https://taskuatapi.hisoft.vn';
  // String link = 'https://1922-27-3-237-129.ngrok-free.app';
  Future<ResultLogin?> callLoginAPI(LoginUser loginUser) async {
    var url = Uri.parse('${link}/api/User/Login');
    // var url = Uri.https('localhost:7166', 'api/User/Login');
    final body =
        jsonEncode({"email": loginUser.email, "password": loginUser.password});
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      // return auth.signInWithEmailAndPassword(loginUser.phone, loginUser.password);
      Map<String, dynamic> responseBody = json.decode(response.body);
      Map<String, dynamic> result = responseBody;

      return ResultLogin.fromMap(result);
    }
  }

  Future<String> callRegisterAPI(SignUpUser signUpUser) async {
    var url = Uri.parse('${link}/api/User/Register');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "userName": signUpUser.phone,
      "password": signUpUser.password,
      "email": signUpUser.email,
      "firstName": signUpUser.firstName,
      "lastName": signUpUser.lastName,
      "address": signUpUser.address,
      "image": signUpUser.image,
      "dob": signUpUser.dob,
      "phoneNumber": signUpUser.phone,
      "gender": signUpUser.gender,
      "bookingStatus": false,
      "banStatus": false,
      "dateCreated": signUpUser.DateCreated
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);

      return response.body;
    }
  }

  Future<SignUpUser?> getUserByEmail(String email) async {
    var url = Uri.parse('${link}/api/User/$email');
    // var url = Uri.https('localhost:7166', 'api/User/$email');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return SignUpUser.fromMap(json.decode(response.body), '');
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<SignUpUser?> getUserById(String id) async {
    var url = Uri.parse('${link}/api/User/getById/$id');
    // var url = Uri.https('localhost:7166', 'api/User/getById/$id');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return SignUpUser.fromMap(json.decode(response.body), '');
    } else {
      print("response body");
      print(response.statusCode);
      return null;
    }
  }

  Future<Role?> getUserRole(String userId) async {
    var url = Uri.parse('${link}/api/User/getUserRole/$userId');
    // var url = Uri.https('localhost:7166', 'api/User/getUserRole/$userId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return Role.fromMap(json.decode(response.body));
    } else {
      print("${response.statusCode} getUserRole");
    }
  }

  Future<void> updateUserbyUID(SignUpUser signUpUser) async {
    var url = Uri.parse('${link}/api/User');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    final body = jsonEncode({
      "id": signUpUser.userID,
      "phoneNumber": signUpUser.phone,
      "firstname": signUpUser.firstName,
      "email": signUpUser.email,
      "address": signUpUser.address,
      "image": signUpUser.image,
      "dob": signUpUser.dob,
      "gender": signUpUser.gender
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      print(response.body);
      throw Exception('Failed to update User');
    }
  }

  Future<bool> updatePhysio(PhysiotherapistModel physio) async {
    var url = Uri.parse('${link}/api/Physiotherapist');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    final body = jsonEncode({
      "physiotherapistID": physio.physiotherapistID,
      "userID": physio.userID,
      "specialize": physio.specialize,
      "skill": physio.skill,
      "scheduleStatus": physio.scheduleStatus,
      "isDeleted": false,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      throw Exception('Failed to update User');
    }
  }

  Future<List<Exercise>> getListExerciseByCategoryID(String categoryId) async {
    var url = Uri.parse('${link}/api/Exercise/GetByCategoryId/$categoryId');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Exercise> list = List<Exercise>.from(
          jsonResult.map((model) => Exercise.fromMap(model)));

      if (list == null) {
        throw Exception('Exercise  List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load exercise  list');
    }
  }

  Future<List<ExerciseDetail1>> getExerciseDetailByExerciseID(
      {String? query, String? exerciseID}) async {
    var url =
        Uri.parse('${link}/api/ExerciseDetail/GetByExerciseID/$exerciseID');
    // var url = Uri.https('localhost:7166', 'api/ExerciseDetail/GetByExerciseID/$exerciseID');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<ExerciseDetail1> list = List<ExerciseDetail1>.from(
          jsonResult.map((model) => ExerciseDetail1.fromMap(model)).toList());
      if (query != null) {
        print(query);
        list = list
            .where((element) =>
                element.detailName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      if (list == null) {
        throw Exception('Exercise Detail List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load exercise detail list');
    }
  }

  Future<bool> AddFavoriteExercise(FavoriteExercise favoriteExercise) async {
    var url = Uri.parse('${link}/api/FavoriteExercise/Create');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "userID": favoriteExercise.userID,
      "exerciseDetailID": favoriteExercise.exerciseDetailID,
      "isDeleted": false,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);

      return false;
    }
  }

  Future<bool> DeleteFavoriteExerciseByExerciseDetailIDAndUserID(
      String detailID, String userID) async {
    var url = Uri.parse(
        '${link}/api/FavoriteExercise/DeleteByExerciseDetailIDAndUserID?detailID=$detailID&userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<bool> DeleteProblem(String problemID) async {
    var url = Uri.parse('${link}/api/Problem/$problemID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<List<CategoryModel>> getAllCategory({String? query}) async {
    var url = Uri.parse('${link}/api/Category');
    // var url = Uri.https('localhost:7166', 'api/Category');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      // "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<CategoryModel> list = List<CategoryModel>.from(
          jsonResult.map((model) => CategoryModel.fromMap(model)).toList());

      if (query != null) {
        print(query);
        list = list
            .where((element) => element.categoryName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      if (list == null) {
        throw Exception('Category List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load categoryList');
    }
  }

  // Future<List<BookingDetail>> getAllBookingDetail() async {
  //   var url = Uri.parse('${link}/api/BookingDetail');
  //   // var url = Uri.https('localhost:7166', 'api/BookingDetail');
  //   final headers = {
  //     "Accept": "application/json",
  //     "content-type": "application/json",
  //     "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
  //   };
  //   var response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200) {
  //     Iterable jsonResult = json.decode(response.body);
  //     List<BookingDetail> list = List<BookingDetail>.from(
  //         jsonResult.map((model) => BookingDetail.fromMap(model)));
  //     if (list == null) {
  //       throw Exception('BookingDetail List null');
  //     } else {
  //       return list;
  //     }
  //   } else {
  //     throw Exception('Failed to load BookingDetail');
  //   }
  // }

  Future<List<BookingDetail>> GetAllBookingDetailBill(String userID) async {
    var url = Uri.parse(
        '${link}/api/BookingDetail/GetAllBookingDetailBill?userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/BookingDetail');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)));
      if (list == null) {
        throw Exception('BookingDetail List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load BookingDetail');
    }
  }

  Future<List<BookingDetail>> GetAllBookingDetailLongTermNotPayment(
      String userID) async {
    var url = Uri.parse(
        '${link}/api/BookingDetail/GetAllBookingDetailLongTermNotPayment?userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/BookingDetail');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)));
      if (list == null) {
        throw Exception('BookingDetail List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load BookingDetail');
    }
  }

  Future<List<BookingDetail>> GetAllBookingDetailByPhysioID(
      String physioID) async {
    var url = Uri.parse(
        '${link}/api/BookingDetail/GetAllBookingDetailByPhysioID?physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/BookingDetail');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)));
      if (list == null) {
        throw Exception('BookingDetail List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load BookingDetail');
    }
  }

  Future<List<BookingDetail>> getAllBookingDetailByUserIDAndTypeOfSlot(
      String userID, String typeOfSlot) async {
    var url = Uri.parse(
        '${link}/api/BookingDetail/GetByUserIDAndTypeOfSlot?userID=$userID&typeOfSlot=$typeOfSlot');
    // var url = Uri.https('localhost:7166', 'api/BookingDetail');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)));
      if (list == null) {
        throw Exception('BookingDetail List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load BookingDetail');
    }
  }

  Future<List<BookingDetail>?>
      getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
    String physioID,
    String typeOfSlot,
    int shortTermStatus,
    int longTermStatus,
    String? query,
  ) async {
    var url = Uri.parse('${link}/api/BookingDetail/'
        'GetAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus'
        '?physioID=$physioID'
        '&typeOfSlot=$typeOfSlot'
        '&shortTermStatus=$shortTermStatus'
        '&longTermStatus=$longTermStatus');
    // var url = Uri.https('localhost:7166', 'api/BookingDetail');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)).toList());
      if (query != null) {
        print(query);
        list = list
            .where((element) => element.bookingSchedule!.signUpUser!.firstName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }

      if (list.isEmpty) {
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load BookingDetail');
    }
  }

  Future<List<ExerciseResource>> getAllExerciseResource() async {
    var url = Uri.parse('${link}/api/ExerciseResource');
    // var url = Uri.https('localhost:7166', 'api/ExerciseResource');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<ExerciseResource> list = List<ExerciseResource>.from(
          jsonResult.map((model) => ExerciseResource.fromMap(model)));
      if (list == null) {
        throw Exception('ExerciseResource List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load ExerciseResource');
    }
  }

  Future<List<ExerciseResource>> getExerciseResourceByExerciseDetailID(
      String detailID, String? query) async {
    var url = Uri.parse(
        '${link}/api/ExerciseResource/GetByExerciseDetailId/$detailID');
    // var url = Uri.https('localhost:7166', 'api/ExerciseDetail/GetByExerciseID/$exerciseID');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<ExerciseResource> list = List<ExerciseResource>.from(
          jsonResult.map((model) => ExerciseResource.fromMap(model)).toList());
      if (query != null) {
        print(query);
        list = list
            .where((element) => element.resourceName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      if (list == null) {
        throw Exception('ExerciseResource List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load exercise resource ');
    }
  }

  Future<List<FeedbackModel>> getAllFeedback() async {
    var url = Uri.parse('${link}/api/Feedback');
    // var url = Uri.https('localhost:7166', 'api/Feedback');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<FeedbackModel> list = List<FeedbackModel>.from(
          jsonResult.map((model) => FeedbackModel.fromMap(model)));
      if (list == null) {
        throw Exception('FeedbackModel List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load FeedbackModel');
    }
  }

  Future<List<MedicalRecord>> getAllMedicalRecord() async {
    var url = Uri.parse('${link}/api/MedicalRecord');
    // var url = Uri.https('localhost:7166', 'api/MedicalRecord');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<MedicalRecord> list = List<MedicalRecord>.from(
          jsonResult.map((model) => MedicalRecord.fromMap(model)));
      if (list == null) {
        throw Exception('MedicalRecord List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load MedicalRecord');
    }
  }

  Future<void> updateMedicalRecordbysubIDandMedicalID(
      MedicalRecord medicalRecord) async {
    var url = Uri.parse('${link}/api/MedicalRecord');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "medicalRecordID": medicalRecord.medicalRecordID,
      "subProfileID": medicalRecord.subProfileID,
      "problem": medicalRecord.problem,
      "difficult": medicalRecord.difficulty,
      "injury": medicalRecord.injury,
      "curing": medicalRecord.curing,
      "medicine": medicalRecord.medicine,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      print(response.body);
      throw Exception('Failed to update MeidicalRecord');
    }
  }

  Future<void> updateExerciseDetail(ExerciseDetail1 exerciseDetail1) async {
    var url = Uri.parse('${link}/api/ExerciseDetail');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "exerciseDetailID": exerciseDetail1.exerciseDetailID,
      "exerciseID": exerciseDetail1.exerciseID,
      "detailName": exerciseDetail1.detailName,
      "set": exerciseDetail1.set,
      "description": exerciseDetail1.description,
      "favoriteStatus": exerciseDetail1.favoriteStatus,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      print(response.body);
      throw Exception('Failed to update Exercise Detail');
    }
  }

  Future<MedicalRecord?> getMedicalRecordByUserIDAndRelationName(
      String userID, String relationName) async {
    var url = Uri.parse(
        '${link}/api/MedicalRecord/GetByRelationNameAndUserID?relationName=$relationName&userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/MedicalRecord');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return MedicalRecord.fromMap(json.decode(response.body));
    } else {
      // throw Exception('Failed to load MedicalRecord');
      return MedicalRecord(
        subProfileID: null,
        curing: null,
        difficulty: null,
        injury: null,
        medicalRecordID: null,
        medicine: null,
        problem: null,
        subProfile: null,
      );
    }
  }

  Future<MedicalRecord?> getMedicalRecordBySubProfileID(String subID) async {
    var url =
        Uri.parse('${link}/api/MedicalRecord/GetBySubProfileID?subID=$subID');
    // var url = Uri.https('localhost:7166', 'api/MedicalRecord');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return MedicalRecord.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load MedicalRecord');
    }
  }

  Future<MedicalRecord?> createMedicalRecord(
      MedicalRecord medicalRecord) async {
    var url = Uri.parse('${link}/api/MedicalRecord/Create');
    // var url = Uri.https('localhost:7166', 'api/MedicalRecord/Create');

    final body = jsonEncode({
      "subProfileID": medicalRecord.subProfileID,
      "problem": medicalRecord.problem,
      "difficult": medicalRecord.difficulty,
      "injury": medicalRecord.injury,
      "curing": medicalRecord.curing,
      "medicine": medicalRecord.medicine,
      "isDeleted": false,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return MedicalRecord.fromMap(json.decode(response.body));
    } else {}
  }

  Future<MedicalRecord?> updateMedicalRecord(
      MedicalRecord medicalRecord) async {
    var url = Uri.parse('${link}/api/MedicalRecord');
    // var url = Uri.https('localhost:7166', 'api/MedicalRecord/Create');

    final body = jsonEncode({
      "medicalRecordID": medicalRecord.medicalRecordID,
      "subProfileID": medicalRecord.subProfileID,
      "problem": medicalRecord.problem,
      "difficult": medicalRecord.difficulty,
      "injury": medicalRecord.injury,
      "curing": medicalRecord.curing,
      "medicine": medicalRecord.medicine,
      "isDeleted": false,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.put(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return MedicalRecord.fromMap(json.decode(response.body));
    } else {}
  }

  Future<List<PhysiotherapistModel>> getAllPhysiotherapist() async {
    var url = Uri.parse('${link}/api/Physiotherapist');
    // var url = Uri.https('localhost:7166', 'api/Physiotherapist');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<PhysiotherapistModel> list = List<PhysiotherapistModel>.from(
          jsonResult.map((model) => PhysiotherapistModel.fromMap(model)));
      if (list == null) {
        throw Exception('Physiotherapist List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Physiotherapist');
    }
  }

  Future<PhysiotherapistModel> getPhysiotherapistByUserID(String id) async {
    var url = Uri.parse(
        '${link}/api/Physiotherapist/GetPhysiotherapistByUserID?userID=$id');
    // var url = Uri.https('localhost:7166', 'api/Physiotherapist');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return PhysiotherapistModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load Physiotherapist');
    }
  }

  Future<List<PhysiotherapistModel>> getAllActivePhysiotherapist() async {
    var url =
        Uri.parse('${link}/api/Physiotherapist/GetAllActivePhysiotherapist');
    // var url = Uri.https('localhost:7166', 'api/Physiotherapist');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<PhysiotherapistModel> list = List<PhysiotherapistModel>.from(
          jsonResult.map((model) => PhysiotherapistModel.fromMap(model)));
      if (list == null) {
        throw Exception('Active Physiotherapist List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Active Physiotherapist');
    }
  }

  Future<List<Schedule>> getAllSchedule() async {
    var url = Uri.parse('${link}/api/Schedule');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Schedule> list = List<Schedule>.from(
          jsonResult.map((model) => Schedule.fromMap(model)));
      if (list == null) {
        throw Exception('Schedule List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Schedule');
    }
  }

  Future<dynamic> AddLongTermSlotByPhysioID(Slot slot, String physioID) async {
    var url = Uri.parse(
        '${link}/api/Slot/AddLongTermSlotByPhysioID?physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "slotName": slot.slotName,
      "timeStart": slot.timeStart,
      "timeEnd": slot.timeEnd,
      "available": true
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}"
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      addSlotStatus = 200;
      return Slot.fromMap(json.decode(response.body));
    } else {
      addSlotStatus = 400;
      Iterable jsonResult = json.decode(response.body);

      List<Slot> list =
          List<Slot>.from(jsonResult.map((model) => Slot.fromMap(model)));
      if (list == null) {
        throw Exception('Slot List null');
      } else {
        return list;
      }
    }
  }

  Future<Schedule> AddSchedule(Schedule schedule) async {
    var url = Uri.parse('${link}/api/Schedule');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "slotID": schedule.slotID,
      "physiotherapistID": schedule.physiotherapistID,
      "typeOfSlotID": schedule.typeOfSlotID,
      "description": schedule.description,
      "physioBookingStatus": schedule.physioBookingStatus
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return Schedule.fromMap(json.decode(response.body));
    } else {
      print(response.body);

      throw Exception("failed to add Schedule");
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    var url = Uri.parse('${link}/api/Schedule');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "scheduleID": schedule.scheduleID,
      "slotID": schedule.slotID,
      "physiotherapistID": schedule.physiotherapistID,
      "typeOfSlotID": schedule.typeOfSlotID,
      "description": schedule.description,
      "physioBookingStatus": schedule.physioBookingStatus,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      print(response.body);
      throw Exception('Failed to load Schedule');
    }
  }

  Future<void> updateBookingDetailStatus(BookingDetail bookingDetail) async {
    var url = Uri.parse('${link}/api/BookingDetail');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "bookingDetailID": bookingDetail.bookingDetailID,
      "bookingScheduleID": bookingDetail.bookingScheduleID,
      "imageUrl": bookingDetail.imageUrl,
      "paymentMoney": bookingDetail.paymentMoney,
      "longtermStatus": bookingDetail.longtermStatus,
      "shorttermStatus": bookingDetail.shorttermStatus,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load Schedule');
    }
  }

  Future<dynamic> updateSlot(Slot slot, String physioID) async {
    var url = Uri.parse('${link}/api/Slot?physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "slotID": slot.slotID,
      "slotName": slot.slotName,
      "timeStart": slot.timeStart,
      "timeEnd": slot.timeEnd,
      "available": slot.available,
      "isDeleted": false,
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      updateSlotStatus = 200;
      return Slot.fromMap(json.decode(response.body));
    } else {
      print(response.body);
      updateSlotStatus = 400;
      Iterable jsonResult = json.decode(response.body);

      List<Slot> list =
          List<Slot>.from(jsonResult.map((model) => Slot.fromMap(model)));
      if (list == null) {
        throw Exception('Slot List null');
      } else {
        return list;
      }
    }
  }

  Future<List<BookingDetail>?> GetLongTermLists(String physioID) async {
    var url = Uri.parse(
        '${link}/api/BookingDetail/GetLongTermLists?physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<BookingDetail> list = List<BookingDetail>.from(
          jsonResult.map((model) => BookingDetail.fromMap(model)));

      if (list == null) {
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load List Long term');
    }
  }

  Future<List<Schedule>?> getallSlotByPhysiotherapistID(
      String physiotherapistID, String? query) async {
    var url = Uri.parse(
        '${link}/api/Schedule/getAllSlotByPhysiotherapistID/$physiotherapistID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Schedule> list = List<Schedule>.from(
          jsonResult.map((model) => Schedule.fromMap(model)).toList());
      if (query != null) {
        print(query);
        list = list
            .where((element) => element.slot!.slotName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }

      if (list == null) {
        print("List Schedule Null");
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Schedule List');
    }
  }

  Future<List<Schedule>?> getallSlotByPhysiotherapistIDAndTypeOfSlot(
      String physiotherapistID, String typeOfSlot) async {
    var url = Uri.parse(
        '${link}/api/Schedule/GetAllSlotByPhysiotherapistIDAndTypeOfSlot/$physiotherapistID?typeOfSlot=$typeOfSlot');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Schedule> list = List<Schedule>.from(
          jsonResult.map((model) => Schedule.fromMap(model)));

      if (list == null) {
        print("List Schedule Null");
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Schedule List');
    }
  }

  Future<List<Slot>> GetShortTermSlotByDateAndPhysioID(
      String date, String physioID) async {
    var url = Uri.parse(
        '${link}/api/Slot/GetShortTermSlotByDateAndPhysioID/$date?physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Slot> list =
          List<Slot>.from(jsonResult.map((model) => Slot.fromMap(model)));

      if (list == null) {
        print("List Schedule Null");
        throw Exception("List Schedule Null");
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Schedule List');
    }
  }

  Future<List<Schedule>> GetAllSlotTypeNotAssignedByDateAndPhysioID(
      String date, String physioID) async {
    var url = Uri.parse(
        '${link}/api/Schedule/GetAllSlotTypeNotAssignedByDateAndPhysioID?date=$date&physioID=$physioID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Schedule> list = List<Schedule>.from(
          jsonResult.map((model) => Schedule.fromMap(model)));

      if (list == null) {
        throw Exception('Schedule List null');
      } else {
        return list;
      }
    } else {
      print(response.body);
      throw Exception('Failed to load Schedule List');
    }
  }

  Future<List<Slot>> GetAllSlotByDateAndTypeOfSlot(
      String date, String typeOfSlot) async {
    var url = Uri.parse(
        '${link}/api/Slot/GetByDateAndTypeOfSlot?date=$date&typeOfSlot=$typeOfSlot');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Slot> list =
          List<Slot>.from(jsonResult.map((model) => Slot.fromMap(model)));

      if (list == null) {
        throw Exception('Slot List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Slot List');
    }
  }

  Future<int> getNumberOfPhysioRegisterOnSlot(String slotID) async {
    var url =
        Uri.parse('${link}/api/Schedule/GetNumberOfPhysioRegister/$slotID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load number of physio register on slot');
    }
  }

  Future<List<Schedule>> getallPhysiotherapistBySlotTimeAndSkillAndTypeOfSlot(
      String timeStart, String timeEnd, String skill, String typeOfSlot) async {
    var url = Uri.parse(
        '${link}/api/Schedule/GetAllPhysiotherapistBySlotTimeAndSkillAndTypeOfSlot?timeStart=$timeStart&timeEnd=$timeEnd&skill=$skill&typeOfSlot=$typeOfSlot');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Schedule> list = List<Schedule>.from(
          jsonResult.map((model) => Schedule.fromMap(model)));

      if (list == null) {
        throw Exception('Physiotherapist List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Physiotherapist List');
    }
  }

  Future<List<Slot>> getAllSlot() async {
    var url = Uri.parse('${link}/api/Slot');
    // var url = Uri.https('localhost:7166', 'api/Slot');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Slot> list =
          List<Slot>.from(jsonResult.map((model) => Slot.fromMap(model)));
      if (list == null) {
        throw Exception('Slot List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Slot');
    }
  }

  Future<List<SubProfile>> getAllSubProfile() async {
    var url = Uri.parse('${link}/api/SubProfile');
    // var url = Uri.https('localhost:7166', 'api/SubProfile');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<SubProfile> list = List<SubProfile>.from(
          jsonResult.map((model) => SubProfile.fromMap(model)));
      if (list == null) {
        throw Exception('SubProfile List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load SubProfile');
    }
  }

  Future<SubProfile> AddSubProfile(SubProfile subProfile) async {
    var url = Uri.parse('${link}/api/SubProfile/Create');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "userID": subProfile.userID,
      "relationId": subProfile.relationID,
      "subName": subProfile.subName,
      "dateOfBirth": subProfile.dob,
      "isDeleted": false
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return SubProfile.fromMap(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception("failed to add subprofile");
    }
  }

  Future<dynamic> ChangePassword(
      SignUpUser signUpUser, String oldPass, String newPass) async {
    var url = Uri.parse('${link}/api/User/ChangePassword');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "id": signUpUser.userID,
      "oldPassword": oldPass,
      "newPassword": newPass,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return json.decode(response.body);
    }
  }

  Future<void> updateSubprofile(SubProfile subProfile) async {
    var url = Uri.parse('${link}/api/SubProfile');
    // var url = Uri.https('localhost:7166', 'api/Schedule');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    final body = jsonEncode({
      "userID": subProfile.userID,
      "profileID": subProfile.profileID,
      "relationId": subProfile.relationID,
      "subName": subProfile.subName,
      "dateOfBirth": subProfile.dob,
      "isDeleted": false
    });
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
    } else {
      print(response.body);
      throw Exception('Failed to update subProfile');
    }
  }

  Future<dynamic> CheckRegisterMember(SignUpUser signUpUser) async {
    var url = Uri.parse('${link}/api/User/CheckRegisterMember');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    final body = jsonEncode({
      "userName": signUpUser.phone,
      "password": "a",
      "email": signUpUser.email,
      "firstName": signUpUser.firstName,
      "lastName": signUpUser.lastName,
      "address": signUpUser.address,
      "image": signUpUser.image,
      "dob": signUpUser.dob,
      "phoneNumber": signUpUser.phone,
      "gender": signUpUser.gender,
      "bookingStatus": false,
      "banStatus": false,
    });
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);
      Iterable jsonResult = json.decode(response.body);
      List<ErrorModel> list = List<ErrorModel>.from(
          jsonResult.map((model) => ErrorModel.fromMap(model)));

      if (list == null) {
        print("List null");
      } else {
        return list;
      }
    }
  }

  Future<String> CheckExistEmail(String email) async {
    var url = Uri.parse('${link}/api/User/CheckExistEmail?email=$email');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future<String> ResetPassword(String email, String newPassword) async {
    var url = Uri.parse(
        '${link}/api/User/ResetPasswordMobile?email=$email&newPassword=$newPassword');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future<TypeOfSlot> GetTypeOfSlotByTypeName(String typeName) async {
    var url =
        Uri.parse('${link}/api/TypeOfSlot/GetByTypeName?typeName=$typeName');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return TypeOfSlot.fromMap(json.decode(response.body));
    } else {
      throw Exception("failed to add subprofile");
    }
  }

  Future<List<SubProfile>?> getallSubProfileByUserId(
      String userId, String? query) async {
    var url = Uri.parse('${link}/api/SubProfile/GetByUserId/$userId');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<SubProfile> list = List<SubProfile>.from(
          jsonResult.map((model) => SubProfile.fromMap(model)).toList());
      if (query != null) {
        print(query);
        list = list
            .where((element) =>
                element.subName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      if (list == null) {
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load SubProfile List');
    }
  }

  Future<List<Problem1>?> getProblemByMedicalRecordID(
      String medicalRecordID) async {
    var url = Uri.parse(
        '${link}/api/Problem/GetByMedicalRecordID?medicalRecordID=$medicalRecordID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Problem1> list = List<Problem1>.from(
          jsonResult.map((model) => Problem1.FromMap(model)));

      if (list == null) {
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Problem List');
    }
  }

  Future<SubProfile> getSubProfileBySubNameAndUserID(
      String subName, String userID) async {
    var url = Uri.parse(
        '${link}/api/SubProfile/GetBySubNameAndUserID?subName=$subName&userID=$userID');

    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return SubProfile.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load SubProfile ');
    }
  }

  Future<List<SubProfile>?> getallSubProfileByUserIdAndSlotID(
      String userId, String slotID) async {
    var url = Uri.parse(
        '${link}/api/SubProfile/GetByUserIdAndSlotID?userId=$userId&slotID=$slotID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<SubProfile> list = List<SubProfile>.from(
          jsonResult.map((model) => SubProfile.fromMap(model)));

      if (list == null) {
        print("List SubProfile Null");
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load SubProfile List');
    }
  }

  Future<Relationship> getRelationByRelationName(String relationName) async {
    var url =
        Uri.parse('${link}/api/Relationship/GetByRelationName/$relationName');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return Relationship.fromMap(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<BookingDetail> getBookingDetailByID(String bookingDetailID) async {
    var url = Uri.parse('${link}/api/BookingDetail/$bookingDetailID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return BookingDetail.fromMap(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<BookingSchedule> getBookingScheduleByID(
      String bookingScheduleID) async {
    var url = Uri.parse('${link}/api/BookingSchedule/$bookingScheduleID');
    // var url = Uri.https('localhost:7166', 'api/Exercise/GetByCategoryID/$categoryId');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return BookingSchedule.fromMap(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Relationship>> getAllRelationship() async {
    var url = Uri.parse('${link}/api/Relationship');
    // var url = Uri.https('localhost:7166', 'api/TypeOfSlot');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<Relationship> list = List<Relationship>.from(
          jsonResult.map((model) => Relationship.fromMap(model)));
      if (list == null) {
        throw Exception('Relationship List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Relationship');
    }
  }

  Future<List<TypeOfSlot>> getAllTypeOfSlot() async {
    var url = Uri.parse('${link}/api/TypeOfSlot');
    // var url = Uri.https('localhost:7166', 'api/TypeOfSlot');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<TypeOfSlot> list = List<TypeOfSlot>.from(
          jsonResult.map((model) => TypeOfSlot.fromMap(model)));
      if (list == null) {
        throw Exception('TypeOfSlot List null');
      } else {
        list.forEach((element) {
          print(element.typeName);
        });
        return list;
      }
    } else {
      throw Exception('Failed to load TypeOfSlot');
    }
  }

  Future<List<FavoriteExercise>> getAllFavoriteExerciseByUserID(
      String userID) async {
    var url =
        Uri.parse('${link}/api/FavoriteExercise/GetAllByUserID?userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/UserExercise');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body);
      List<FavoriteExercise> list = List<FavoriteExercise>.from(
          jsonResult.map((model) => FavoriteExercise.fromMap(model)));
      if (list == null) {
        throw Exception('Favorite Exercise List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Favorite Exercise list');
    }
  }

  Future<BookingSchedule?> addBookingSchedule(
      BookingSchedule bookingSchedule) async {
    var url = Uri.parse('${link}/api/BookingSchedule/Create');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "userID": bookingSchedule.userID,
      "profileID": bookingSchedule.subProfileID,
      "scheduleID": bookingSchedule.scheduleID,
      "dateBooking": bookingSchedule.dateBooking,
      "timeBooking": bookingSchedule.timeBooking,
      "status": true
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return BookingSchedule.fromMap(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<BookingDetail> addBookingDetail(BookingDetail bookingDetail) async {
    var url = Uri.parse('${link}/api/BookingDetail/Create');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "bookingScheduleID": bookingDetail.bookingScheduleID,
      "imageUrl": bookingDetail.imageUrl,
      "paymentMoney": bookingDetail.paymentMoney,
      "longtermStatus": bookingDetail.longtermStatus,
      "shorttermStatus": bookingDetail.shorttermStatus,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return BookingDetail.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to add BookingDetail');
    }
  }

  Future<bool> deleteBookingDetailbyID(String bookingDetailID) async {
    var url = Uri.parse('${link}/api/BookingDetail/$bookingDetailID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "id": bookingDetailID,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.delete(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete BookingDetail');
    }
  }

  Future<bool> deleteBookingSchedulebyID(String bookingScheduleID) async {
    var url = Uri.parse('${link}/api/BookingSchedule/$bookingScheduleID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "id": bookingScheduleID,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.delete(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete BookingDetail');
    }
  }

  Future<bool> deleteSlotbyID(String slotID) async {
    var url = Uri.parse('${link}/api/Slot/$slotID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "id": slotID,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.delete(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete Slot');
    }
  }

  Future<Problem1?> addProblem(Problem1 problem) async {
    var url = Uri.parse('${link}/api/Problem/Create');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "categoryID": problem.categoryID,
      "medicalRecordID": problem.medicalRecordID,
      "isDeleted": false
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return Problem1.FromMap(json.decode(response.body));
    } else {}
  }

  Future<Problem1?> updateProblem(Problem1 problem) async {
    var url = Uri.parse('${link}/api/Problem');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "problemID": problem.problemID,
      "categoryID": problem.categoryID,
      "medicalRecordID": problem.medicalRecordID,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}",
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return Problem1.FromMap(json.decode(response.body));
    } else {}
  }

  Future<String> addNotification(NotificationModel notification) async {
    var url = Uri.parse('${link}/api/Notification');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final body = jsonEncode({
      "action": notification.action,
      "description": notification.description,
      "subject": notification.subject,
      "content": notification.content,
      "userId": notification.userID
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}"
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return json.encode(response.body);
    } else {
      throw Exception('Failed to add notification');
    }
  }

  Future<List<NotificationModel>> getAllNotification() async {
    var url = Uri.parse(
        '${link}/api/Notification?PageIndex=1&PageSize=10&SortKey=DateCreated&SortOrder=ASC');
    // var url = Uri.https('localhost:7166', 'api/UserExercise');
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}"
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Iterable jsonResult = json.decode(response.body)['data'];
      List<NotificationModel> list = List<NotificationModel>.from(
          jsonResult.map((model) => NotificationModel.fromMap(model)));
      if (list == null) {
        throw Exception('Notification List null');
      } else {
        return list;
      }
    } else {
      throw Exception('Failed to load Notification List');
    }
  }

  Future<bool> seenNotification(String userID) async {
    var url = Uri.parse('${link}/api/Notification?userID=$userID');
    // var url = Uri.https('localhost:7166', 'api/User/Register');

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${sharedResultLogin!.accessToken}"
    };
    var response = await http.put(url, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      throw Exception('Failed to seen notification');
    }
  }

  Future<String> callVNPayGW(PaymentModel paymentModel) async {
    var url = Uri.parse('${link}/api/Payment/callVNPayGW');

    final body = jsonEncode({
      "orderId": paymentModel.orderId,
      "amount": paymentModel.amount,
      "email": paymentModel.email,
    });
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);

      return response.body;
    }
  }
}
