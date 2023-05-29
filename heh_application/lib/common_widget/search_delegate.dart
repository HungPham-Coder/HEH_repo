import 'package:flutter/material.dart';
import 'package:heh_application/Exercise%20Page/detail.dart';
import 'package:heh_application/Exercise%20Page/exercise.dart';
import 'package:heh_application/Exercise%20Page/resource.dart';
import 'package:heh_application/Exercise%20Page/resourceDetail.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/personalFam.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/exercise_model/exercise.dart';
import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Member page/Profile page/Family Page/family.dart';
import '../services/auth.dart';

class SearchCategory extends SearchDelegate {
  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
        future: CallAPI().getAllCategory(query: query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MenuListView(
                  icon: snapshot.data![index].iconUrl!,
                  text: snapshot.data![index].categoryName,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExercisePage(
                                categoryID: snapshot.data![index].categoryID)));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<CategoryModel>>(
      future: CallAPI().getAllCategory(query: query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.categoryName);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchExercise extends SearchDelegate {
  final String? categoryID, accesstoken;
  SearchExercise(this.categoryID, this.accesstoken);

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return FutureBuilder<List<Exercise>?>(
        future: auth.getListExerciseByCategoryID(
            categoryID!, sharedResultLogin!.accessToken!, query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MenuListView(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/category%2Fbackache.png?alt=media&token=56f8cdbd-7ca2-46d8-a60b-93cfc4951c91",
                  text: "${snapshot.data![index].exerciseName}",
                  press: () async {
                    // List<ExerciseDetail1> exerciseDetailList = await CallAPI()
                    //     .getExerciseDetailByExerciseID(
                    //         snapshot.data![index].exerciseID);
                    // ExerciseResource exerciseResource = await CallAPI()
                    //     .getExerciseResourceByExerciseDetailID(
                    //         exerciseDetail.exerciseDetailID);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ExerciseDetail(
                        exerciseID: snapshot.data![index].exerciseID,
                      );
                    }));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    final auth = Provider.of<AuthBase>(context, listen: false);
    return FutureBuilder<List<Exercise>?>(
      future: auth.getListExerciseByCategoryID(
          categoryID!, sharedResultLogin!.accessToken!, query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.exerciseName);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchExerciseDetail extends SearchDelegate {
  final String? exerciseID;
  SearchExerciseDetail(this.exerciseID);

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ExerciseDetail1>>(
        future: CallAPI().getExerciseDetailByExerciseID(
            query: query, exerciseID: exerciseID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MenuListView(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbackache.png?alt=media&token=d725e1f5-c106-41f7-9ee5-ade77c464a54",
                  text: "${snapshot.data![index].detailName}",
                  press: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ExerciseResources(
                        exerciseDetail: snapshot.data![index],
                        // exerciseResource: exerciseResource,
                      );
                    }));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<ExerciseDetail1>>(
      future: CallAPI()
          .getExerciseDetailByExerciseID(query: query, exerciseID: exerciseID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var detail in snapshot.data!) {
            suggestions.add(detail.detailName!);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchExerciseResource extends SearchDelegate {
  final String? exerciseDetailID;
  SearchExerciseResource(this.exerciseDetailID);

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != '/search') {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ExerciseResource>?>(
        future: CallAPI()
            .getExerciseResourceByExerciseDetailID(exerciseDetailID!, query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ResourceListView(
                  icon: snapshot.data![index].imageURL!,
                  text: snapshot.data![index].resourceName!,
                  press: () async {
                    // List<ExerciseDetail1> exerciseDetailList =
                    //     await CallAPI()
                    //         .getExerciseDetailByExerciseID(widget
                    //             .exerciseDetail!.exerciseID);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ExerciseResourcesDetail(
                        exerciseResource: snapshot.data![index],
                      );
                    }));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<ExerciseResource>?>(
      future: CallAPI()
          .getExerciseResourceByExerciseDetailID(exerciseDetailID!, query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.resourceName!);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchFamilyName extends SearchDelegate {
  final String? userID;
  SearchFamilyName(this.userID);

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != '/search') {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SubProfile>?>(
        future: CallAPI()
            .getallSubProfileByUserId(sharedCurrentUser!.userID!, query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    DateTime tempDate = new DateFormat("yyyy-MM-dd")
                        .parse(snapshot.data![index].dob!);

                    int age = DateTime.now().year - tempDate.year;

                    return ProfileMenu(
                      icon:
                          "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fperson.svg?alt=media&token=7bef043d-fdb5-4c5b-bb2e-644ee7682345",
                      name: "${snapshot.data![index].subName}",
                      relationship:
                          "${snapshot.data![index].relationship!.relationName} - ",
                      text: "$age tuổi",
                      press: () async {
                        MedicalRecord? medicalRecord = await CallAPI()
                            .getMedicalRecordBySubProfileID(
                                snapshot.data![index].profileID!);
                        // setState(() {
                        sharedSubprofile = snapshot.data![index];
                        // });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FamilyPersonalPage(
                                      subProfile: snapshot.data![index],
                                      medicalRecord: medicalRecord,
                                    ))).then((value) {});
                      },
                    );
                  });
            } else {
              return Center(
                child: Container(),
              );
            }
          } else {
            return Center(
              child: Container(),
            );
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<SubProfile>?>(
      future:
          CallAPI().getallSubProfileByUserId(sharedCurrentUser!.userID!, query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.subName);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchSchedule extends SearchDelegate {
  final String? physiotherapistID;
  SearchSchedule(this.physiotherapistID);

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != '/search') {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Schedule>?>(
      future: CallAPI().getallSlotByPhysiotherapistID(
          sharedPhysiotherapist!.physiotherapistID, query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return RefreshIndicator(
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DateTime dateStart = new DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(snapshot.data![index].slot!.timeStart);
                    String startStr = DateFormat("HH:mm").format(dateStart);
                    DateTime dateEnd = new DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(snapshot.data![index].slot!.timeEnd);
                    String endStr = DateFormat("HH:mm").format(dateEnd);
                    print(snapshot.data![index].slot!.slotName);
                    // print(snapshot.data![index].typeOfSlot!.typeName);
                    return ScheduleMenu(
                      icon:
                          "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                      press: () {},
                      name: snapshot.data![index].slot!.slotName!,
                      time: "Khung giờ: $startStr - $endStr",
                      typeOfSlot: snapshot.data![index].typeOfSlot == null
                          ? "Chưa gán"
                          : snapshot.data![index].typeOfSlot!.typeName,
                    );
                  }),
              onRefresh: () async {
                CallAPI().getallSlotByPhysiotherapistID(
                    sharedPhysiotherapist!.physiotherapistID, query);
              },
            );
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 300),
                child: Text(
                  "Bạn chưa đăng ký khung giờ nào",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 300),
              child: Text(
                "Hiện tại không còn slot cho bạn",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            ),
          );
        }
      },
    );
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<Schedule>?>(
      future: CallAPI().getallSlotByPhysiotherapistID(
          sharedPhysiotherapist!.physiotherapistID, query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.slot!.slotName!);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchDoneAdvice extends SearchDelegate {
  String? physioID, typeOfSlot;
  int? shortTermStatus;
  int? longTermStatus;
  BuildContext context;
  SearchDoneAdvice(
    this.physioID,
    this.typeOfSlot,
    this.longTermStatus,
    this.shortTermStatus,
    this.context,
  );

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        if (ModalRoute.of(context)?.settings.name != '/search') {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<BookingDetail>?>(
        future: CallAPI()
            .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                sharedPhysiotherapist!.physiotherapistID,
                'Tư vấn trị liệu',
                3,
                -1,
                ""),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              List<BookingDetail> listSort = [];
              for (var item in snapshot.data!) {
                if (item.longtermStatus == -1) {
                  listSort.add(item);
                }
              }
              if (listSort.isNotEmpty) {
                return RefreshIndicator(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        bool visible = true;
                        String subName;

                        if (snapshot.data![index].bookingSchedule!.subProfile!
                                .relationship!.relationName ==
                            "Tôi") {
                          visible = false;

                          subName = "";
                        } else {
                          subName = snapshot.data![index].bookingSchedule!
                              .subProfile!.subName;
                        }
                        String date = DateTimeFormat.formatDate(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeStart);
                        String start = DateTimeFormat.formateTime(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeStart);
                        String end = DateTimeFormat.formateTime(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeEnd);
                        if (snapshot.data![index].longtermStatus == -1) {
                          return ServicePaid(
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.jpg?alt=media&token=bcd461f3-e46a-4d99-8a59-0250c520c8f8",
                              date: "$date",
                              name:
                                  "Người đặt: ${snapshot.data![index].bookingSchedule!.signUpUser!.firstName}",
                              subName: subName,
                              time: "$start - $end",
                              status: 'xong',
                              press: () {
                                String bookingScheduleID =
                                    snapshot.data![index].bookingScheduleID;
                                BookingDetail bookingDetail = BookingDetail(
                                    bookingDetailID:
                                        snapshot.data![index].bookingDetailID,
                                    bookingScheduleID: bookingScheduleID,
                                    longtermStatus: 0,
                                    shorttermStatus: 3);
                                CallAPI()
                                    .updateBookingDetailStatus(bookingDetail);

                                Navigator.pop(context);
                              },
                              visible: visible);
                        } else {
                          return Center(
                            child: Container(
                                // padding: const EdgeInsets.symmetric(vertical: 150),
                                // child: Text(
                                //   "Hiện tại đã hết slot có thể đăng ký",
                                //   style: TextStyle(
                                //       color: Colors.grey[500], fontSize: 16),
                                // ),
                                ),
                          );
                        }
                      }),
                  onRefresh: () async {
                    CallAPI()
                        .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                            sharedPhysiotherapist!.physiotherapistID,
                            'Tư vấn trị liệu',
                            3,
                            -1,
                            "");
                  },
                );
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 150),
                    child: Text(
                      "Hiện tại chưa có slot tư vấn trị liệu nào hoàn thành",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: Text(
                    "Hiện tại chưa có slot tư vấn trị liệu nào hoàn thành",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Container(),
            );
          }
        });
  }

  List<String> searchResults = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return FutureBuilder<List<BookingDetail>?>(
      future: CallAPI()
          .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
              sharedPhysiotherapist!.physiotherapistID,
              'Tư vấn trị liệu',
              3,
              -1,
              ""),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          suggestions.clear();
          for (var category in snapshot.data!) {
            suggestions.add(category.bookingSchedule!.signUpUser!.firstName!);
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return ListTile(
                title: Text(
                  suggestion,
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget ServicePaid(
      {required String icon,
      name,
      time,
      date,
      status,
      String? subName,
      required bool visible,
      required VoidCallback press}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 46, 161, 226),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 235, 241, 245)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    icon,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    width: 40,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Visibility(
                            visible: visible,
                            child: Text(
                              "$subName",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Ngày đặt: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Khung giờ: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Trạng thái: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      )),
                  dialog(press: press),
                ],
              )),
        ],
      ),
    );
  }

  Widget dialog({required VoidCallback press}) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Thêm khách hàng'),
          content: const Text(
              'Bạn có muốn thêm khách hàng này vào Điều Trị Dài Hạn?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Hủy'),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: press,
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
