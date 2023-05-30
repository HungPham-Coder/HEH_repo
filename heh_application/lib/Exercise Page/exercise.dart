import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Exercise%20Page/detail.dart';

import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/exercise_model/exercise.dart';
import 'package:heh_application/services/auth.dart';
import 'package:provider/provider.dart';

import '../common_widget/search_delegate.dart';

class ExercisePage extends StatefulWidget {
  ExercisePage({Key? key, required this.categoryID}) : super(key: key);
  String categoryID;
  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Danh sách bài tập ",
          style: TextStyle(fontSize: 23),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchExercise(
                        widget.categoryID, sharedResultLogin!.accessToken!));
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await auth.getListExerciseByCategoryID(
              widget.categoryID, sharedResultLogin!.accessToken!, "");
          setState(() {});
        },
        child: Column(
          children: [
            FutureBuilder<List<Exercise>?>(
                future: auth.getListExerciseByCategoryID(
                    widget.categoryID, sharedResultLogin!.accessToken!, ""),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
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
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 300),
                          child: Text(
                            "Bài tâp trống",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 300),
                        child: Text(
                          "Bài tâp trống",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}


// class MySearchDelegate extends SearchDelegate {
//   List<String> searchResults = ['a', 'b']; //danh sach tim kiem
//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//         IconButton(
//             onPressed: () {
//               if (query.isEmpty) {
//                 close(context, null);
//               } else {
//                 query = '';
//               }
//             },
//             icon: const Icon(Icons.clear))
//       ];
//
//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//       onPressed: () => close(context, null),
//       icon: const Icon(Icons.arrow_back));
//
//   @override
//   Widget buildResults(BuildContext context) => Center(
//         child: Text(query, style: const TextStyle(fontSize: 64)),
//       );
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> suggestions = searchResults.where((searchResult) {
//       final result = searchResult.toLowerCase();
//       final input = query.toLowerCase();
//
//       return result.contains(input);
//     }).toList();
//
//     return ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           final suggestion = suggestions[index];
//
//           return ListTile(
//             title: Text(suggestion),
//             onTap: () {
//               query = suggestion;
//               showResults(context);
//             },
//           );
//         });
//   }
// }
