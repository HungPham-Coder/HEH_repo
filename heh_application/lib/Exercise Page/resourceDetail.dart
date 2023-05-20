import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:video_player/video_player.dart';

class ExerciseResourcesDetail extends StatefulWidget {
  ExerciseResourcesDetail(
      {Key? key,
      // this.exerciseDetail,

      this.exerciseResource,
     })
      : super(key: key);
  ExerciseResource? exerciseResource;

  @override
  State<ExerciseResourcesDetail> createState() =>
      _ExerciseResourcesDetailState();
}

class _ExerciseResourcesDetailState extends State<ExerciseResourcesDetail> {
  late VideoPlayerController _vidController;
  ChewieController? chewieController;
  // late YoutubePlayerController? youtubePlayerController;
  bool isSelected = true;

  // String _videoDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));

  //   return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  // }

  @override
  void initState() {
    initPlayer();
    // loadVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _vidController.dispose();
    chewieController?.dispose();
  }

  void initPlayer() async {
    // widget.exerciseResource!.forEach((element) {
    _vidController = VideoPlayerController.network(widget.exerciseResource!.videoURL!);
    _vidController.addListener(() {
      setState(() {});
    });
    _vidController.initialize().then((value) {
      setState(() {});
    });
    // });

    chewieController = ChewieController(
      videoPlayerController: _vidController,
      aspectRatio: 16 / 9,
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exerciseResource == null) {
      return Scaffold(
        body: Container(
          child: const Center(
              child: Text("Hiện tại không có video hoặc hình ảnh bài tập.")),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(

            title: Text(
              widget.exerciseResource!.exerciseDetail1!.detailName!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                // fontFamily: "Times New Roman",
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 46, 161, 226),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              "Thông tin bài tập",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            widget.exerciseResource!.exerciseDetail1!.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Container(child: Image.network(widget.exerciseResource!.imageURL!)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: _vidController.value.isInitialized
                                ? Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      const Text("Video hướng dẫn",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                      const SizedBox(height: 10),
                                      Stack(
                                        children: [
                                          SizedBox(
                                              height: 200,
                                              child: Chewie(
                                                  controller:
                                                      chewieController!)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )
                                : const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue),
                                    ),
                                  ),
                          ),
                          // ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            ],
          ));
    }
  }
}
