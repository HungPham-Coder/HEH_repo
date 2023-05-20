import 'package:flutter/material.dart';
import 'package:heh_application/Exercise%20Page/resourceDetail.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/models/favorite_exercise.dart';
import 'package:heh_application/services/call_api.dart';

import '../common_widget/search_delegate.dart';

class ExerciseResources extends StatefulWidget {
  ExerciseResources({
    Key? key,

    this.exerciseDetail,
  }) : super(key: key);


  ExerciseDetail1? exerciseDetail;
  // List<ExerciseResource>? exerciseResource;

  @override
  State<ExerciseResources> createState() => _ExerciseResourcesState();
}

class _ExerciseResourcesState extends State<ExerciseResources> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                  widget.exerciseDetail!.favoriteStatus == 0
                      ? Icons.favorite_border
                      : Icons.favorite,
                  color: widget.exerciseDetail!.favoriteStatus == 0
                      ? Colors.white
                      : Colors.red,
                  size: 30),
              onPressed: () async {
                if (widget.exerciseDetail!.favoriteStatus == 0) {
                  setState(() {
                    widget.exerciseDetail!.favoriteStatus = 1;
                  });
                  FavoriteExercise favoriteExercise = FavoriteExercise(
                    exerciseDetailID: widget.exerciseDetail!.exerciseDetailID,
                    userID: sharedCurrentUser!.userID!,
                  );
                  await CallAPI().AddFavoriteExercise(favoriteExercise);
                } else {
                  setState(() {
                    widget.exerciseDetail!.favoriteStatus = 0;
                  });
                  await CallAPI().DeleteFavoriteExerciseByExerciseDetailIDAndUserID(widget.exerciseDetail!.exerciseDetailID, sharedCurrentUser!.userID!);
                }
                await CallAPI().updateExerciseDetail(widget.exerciseDetail!);
              },
            ),
          ],
          title: const Text(
            // widget.exerciseDetail!.detailName!,
            "Các loại tài nguyên",
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
              // fontFamily: "Times New Roman",
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  FutureBuilder<List<ExerciseResource>?>(
                      future: CallAPI().getExerciseResourceByExerciseDetailID(
                          widget.exerciseDetail!.exerciseDetailID),
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
