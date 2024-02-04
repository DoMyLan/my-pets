import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  List<dynamic> finalResult = [];

  final TextEditingController _captionController = TextEditingController();
  var avatar = '';
  var name = '';

  Future<void> selectImage() async {
    List<dynamic> finalResult2 = [];

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    Loading(context);
    var result = await uploadMultiImage(imageFileList);
    Navigator.of(context).pop();
    finalResult2 = result.map((url) => url).toList();
    if (mounted) {
      setState(() {
        finalResult = finalResult2;
      });
    }
  }

  Future<void> _post() async {
    if (mounted) {
      await addPost(_captionController.text.toString(), finalResult);
      setState(() {
        _captionController.clear();
        imageFileList.clear();
      });
    }
  }

  Future<void> openHiveBox() async {
    var currentClient = await getCurrentClient();
    setState(() {
      avatar = currentClient.avatar;
      name = currentClient.role == 'USER'
          ? '${currentClient.firstName} ${currentClient.lastName}'
          : currentClient.name;
    });
  }

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container(); // Return an empty container if widget is disposed
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(avatar),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    name.toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_captionController.text.isEmpty) {
                        notification('Please enter caption', true);
                        return;
                      }
                      Loading(context);
                      await _post();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(
                          48, 96, 96, 1.0), // Điều chỉnh màu nền của nút
                      onPrimary: Colors
                          .white, // Điều chỉnh màu văn bản của nút khi được nhấn
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Post'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 2,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),

              // Conditionally render the image widget
              // if (imageFileList.isNotEmpty)
              //   if (imageFileList.length == 1)
              //     Image.file(
              //       File(imageFileList[0].path),
              //       height: 350.0,
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //     )
              //   else
              //     _slider(finalResult)
              // else
              //   Container(
              //     height: 350.0,
              //     width: double.infinity,
              //     color: Colors.grey.shade300,
              //     child: Center(
              //       child: IconButton(
              //         icon: Icon(Icons.camera_alt),
              //         onPressed: selectImage,
              //       ),
              //     ),
              //   ),
              if (imageFileList.isNotEmpty)
                if (imageFileList.length == 1)
                  Image.file(
                    File(imageFileList[0].path),
                    height: 350.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  _slider(finalResult)
              else
                Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    // child: Icon(Icons.add_a_photo,
                    //     size: 50, color: Colors.grey[400],),

                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    )),

              const SizedBox(height: 50),
              MaterialButton(
                minWidth: double.infinity,
                height: 50,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel timers or stop animations here
    super.dispose();
  }

  Widget _slider(List imageList) {
    return Stack(
      children: [
        CarouselSlider(
          items: imageList
              .map(
                (item) => Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: 20 / 20,
            viewportFraction: 1,

            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        //cấu hình nút chạy ảnh
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 17 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? Colors.red : Colors.teal),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
