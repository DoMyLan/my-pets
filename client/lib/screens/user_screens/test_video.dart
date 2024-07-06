import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/services/upload_video/upload_video.dart';
import 'package:video_player/video_player.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Player Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: VideoPlayerScreen(),
//     );
//   }
// }

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false;
 bool _isPlaying = false; 
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/sample_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoLoaded = true;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      createAudioUpload('${result.files.single.path!}'); 
      await _controller.pause();
      await _controller.dispose();
      setState(() {
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {
              _isVideoLoaded = true;
            });
          });
      });
    }
  }

  void _togglePlayPause() {
    
    if (_controller.value.isPlaying) {
      
      _controller.pause();
       setState(() {
        _isPlaying = false; 
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Container(
        child: _isVideoLoaded
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    IconButton(
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      color: Colors.white,
                      iconSize: 50,
                    ),
                  ],
                ),
              )
            : Icon(
                Icons.add,
                size: 100,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isVideoLoaded ? null : _playVideo,
        tooltip: 'Add Video',
        child: Icon(Icons.add),
      ),
    );
  }
}



