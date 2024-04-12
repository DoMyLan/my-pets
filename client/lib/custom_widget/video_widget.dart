import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/short_video.dart';
import 'package:found_adoption_application/screens/comment_screen.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final ShortVideo videoPost;
  const VideoApp({super.key, required this.videoPost});
  @override
  // ignore: library_private_types_in_public_api
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = true;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(
      widget.videoPost.video, // Thay đổi đường dẫn video ở đây
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Lặp lại video
    _controller.play(); // Tự động phát video
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Visibility(
            visible: !_isPlaying,
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 100,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget
                        .videoPost.avatar), // Replace with your avatar URL
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: _isFavorited ? Colors.red : Colors.grey[300],
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _controller.pause();
                      setState(() {
                        _isPlaying = false;
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentScreen(postId: widget.videoPost.id)));
                    },
                    child: Icon(
                      Icons.mode_comment,
                      color: Colors.grey[300],
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.videoPost.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      widget.videoPost.content,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
