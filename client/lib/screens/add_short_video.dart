import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/upload_video/upload_video.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ShortVideo extends StatefulWidget {
  @override
  State<ShortVideo> createState() => _ShortVideoState();
}

class _ShortVideoState extends State<ShortVideo> {
  bool _isVideoLoaded = false;
  bool _isPlaying = false;
  late VideoPlayerController _controller;
  List<XFile> imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  late String videoPath = '';
  List<PetCustom> pets = [];
  Future<List<PetCustom>>? petFuture;
  String? dropdownValue;

  TextEditingController contentController = TextEditingController();

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
    videoPath = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuFrameUser(
                      userId: currentClient.id,
                    ),
                  ),
                );
              } else if (currentClient.role == 'CENTER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MenuFrameCenter(centerId: currentClient.id),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
        title: Text('Thước phim mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isVideoLoaded
                ? Stack(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      width: MediaQuery.of(context).size.height * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: AspectRatio(
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
                      ),
                    ),
                    Positioned(
                      top: 4.0,
                      left: 10.0,
                      child: TextButton(
                        onPressed: () {
                          //Chuyển đến bài viết cụ thể
                        },
                        child: Text(
                          'Xem trước',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.fromLTRB(20, 5, 20, 5)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(48, 96, 96, 1.0))),
                      ),
                    ),
                  ])
                : Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    width: MediaQuery.of(context).size.height * 0.9,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.video_camera_back,
                              size: 32, color: Color.fromRGBO(48, 96, 96, 1.0)),
                          onPressed: _playVideo,
                        ),
                        Text(
                          'Thêm Video',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(48, 96, 96, 1.0)),
                        ),
                      ],
                    ),
                  ),

            Divider(
              color: Colors.grey.shade800,
              thickness: 2,
              height: 10,
            ),

            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://scontent.fsgn5-3.fna.fbcdn.net/v/t39.30808-6/432743255_3650243288584838_926608697568740804_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=Lbu3y4i21N8Ab4JGggX&_nc_ht=scontent.fsgn5-3.fna&oh=00_AfA0uCd-2oVWkYmf9Ryn-0_jqWeZtCm93E-ek8xULUAsVw&oe=661F2B25'),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Đỗ Mỹ Lan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              //Tạo dropdown Liên kết với thú cưng
                              Text("Liên kết với một thú cưng",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey.shade400,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ],
                          ),
                          Text(
                            '* User',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: 'Viết chú thích hay thêm mô tả...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ],
              ),
            ),

            //button
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  minWidth: 180,
                  height: 50,
                  onPressed: () async {
                    if (videoPath == '') {
                      return;
                    } else {
                      Loading(context);
                      await addPost(
                          contentController.text, [], null, 'VIDEO', videoPath);
                      Navigator.pop(context);
                    }
                  },
                  // defining the shape
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Chia sẻ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _playVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Loading(context);
      String url = await createAudioUpload('${result.files.single.path!}');
      print("url: $url");
      Navigator.pop(context);
      await _controller.pause();
      await _controller.dispose();
      setState(() {
        videoPath = url;
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
}
