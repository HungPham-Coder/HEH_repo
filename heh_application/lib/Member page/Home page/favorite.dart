import 'package:flutter/material.dart';

import 'package:heh_application/Exercise%20Page/resource.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/favorite_exercise.dart';
import 'package:heh_application/services/call_api.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Bài tập yêu thích",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<FavoriteExercise>>(
                future: CallAPI().getAllFavoriteExercise(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return MenuListView(
                              icon:
                                  // snapshot.data![index].exerciseDetail1!.exercise!.iconUrl!,
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbackache.png?alt=media&token=d725e1f5-c106-41f7-9ee5-ade77c464a54",
                              text:
                                  "${snapshot.data![index].exerciseDetail1!.detailName}",
                              press: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExerciseResources(
                                              exerciseDetail: snapshot
                                                  .data![index]
                                                  .exerciseDetail1!,
                                            )));
                              },
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 250),
                          child: Text(
                            "Bạn chưa thêm bài tập yêu thích nào",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 150),
                        // child: Text(
                        //   "Lỗi load bài tâp",
                        //   style:
                        //   TextStyle(color: Colors.grey[500], fontSize: 16),
                        // ),
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
