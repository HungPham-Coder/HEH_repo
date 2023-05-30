import 'package:flutter/material.dart';
import 'package:heh_application/Exercise%20Page/resource.dart';

import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:provider/provider.dart';

import '../common_widget/search_delegate.dart';

class ExerciseDetail extends StatefulWidget {
  ExerciseDetail({Key? key, this.exerciseID}) : super(key: key);
  String? exerciseID;
  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bài tập cụ thể",
          style: TextStyle(fontSize: 23),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchExerciseDetail(widget.exerciseID));
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          CallAPI()
              .getExerciseDetailByExerciseID(exerciseID: widget.exerciseID!);
          setState(() {});
        },
        child: FutureBuilder<List<ExerciseDetail1>>(
            future: CallAPI()
                .getExerciseDetailByExerciseID(exerciseID: widget.exerciseID!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return ListView.builder(
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
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 300),
                      child: Text(
                        "Bài tâp trống",
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
                      "Bài tâp trống",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
