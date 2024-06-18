import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/video_widget.dart';
import 'package:found_adoption_application/models/short_video.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:video_player/video_player.dart';

class ListVideo extends StatefulWidget {
  final String id;
  const ListVideo({super.key, required this.id});

  @override
  State<ListVideo> createState() => _ListVideoState();
}

class _ListVideoState extends State<ListVideo> {
  Future<List<ShortVideo>>? videoFuture;

  @override
  void initState() {
    super.initState();
    videoFuture = getAllVideoPersonal(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: videoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<ShortVideo> videos = snapshot.data as List<ShortVideo>;

            if (videos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_library,
                        size: 50.0), // Adjust the icon and size as needed
                    Text('Chưa có video nào được tải lên'),
                  ],
                ),
              );
            }

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: videos.length,
                itemBuilder: (BuildContext context, int index) {
                  return VideoItem(post: videos[index]);
                });
          }),
    );
  }
}

class VideoItem extends StatefulWidget {
  final ShortVideo post;
  const VideoItem({super.key, required this.post});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.post.video);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoApp(
                      videoPost: widget.post,
                      back: true,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Stack(children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center();
                }
              },
            ),
            Container(
              height: 180.0,
              width: 130.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.8)
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.post.qtyLike.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.comment_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.post.qtyComment.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )
                  ]),
            )
          ]),
        ),
      ),
    );
  }
}
