import 'package:flutter/material.dart';
import 'package:heh_application/Member%20page/Exercise%20Page/resourceDetail.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/services/call_api.dart';

import '../../common_widget/search_delegate.dart';

class ExerciseResources extends StatefulWidget {
  ExerciseResources({
    Key? key,
    this.detailID,
    this.exerciseDetail,
    this.exerciseResource,
  }) : super(key: key);

  String? detailID;
  ExerciseDetail1? exerciseDetail;
  // List<ExerciseResource>? exerciseResource;
  ExerciseResource? exerciseResource;
  @override
  State<ExerciseResources> createState() => _ExerciseResourcesState();
}

class _ExerciseResourcesState extends State<ExerciseResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: MySearchDelegate());
                },
                icon: const Icon(Icons.search)),
          ],
          centerTitle: true,
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
                                  // List<ExerciseResource> exerciseResource =
                                  //     await CallAPI()
                                  //         .getExerciseResourceByExerciseDetailID(
                                  //             snapshot.data![index]
                                  //                 .exerciseDetailID);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    print(widget.exerciseDetail!.description);
                                    // if (exerciseResource != null) {
                                    return ExerciseResourcesDetail(
                                      resourceID: widget.detailID,
                                      // exerciseResource: exerciseResource,
                                      imageURL: snapshot.data![index].imageURL!,
                                      description:
                                          widget.exerciseDetail!.description,
                                      resourceName:
                                          snapshot.data![index].resourceName,
                                      videoURL: snapshot.data![index].videoURL,
                                    );
                                    // }
                                    //  else {
                                    //   return ExerciseResourcesDetail(
                                    //     resourceID: widget.detailID,
                                    //   );
                                    // }
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
