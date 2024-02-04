// import 'package:flutter/material.dart';
// import 'package:found_adoption_application/repository/add_post_api.dart';
// import 'package:found_adoption_application/repository/upload_image_api.dart';
// import 'package:found_adoption_application/screens/feed_screen.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class NewPostScreen extends StatefulWidget {
//   @override
//   _NewPostScreenState createState() => _NewPostScreenState();
// }

// class _NewPostScreenState extends State<NewPostScreen> {
//   List<File> _images = [];
//   // File? _image;
//   final TextEditingController _captionController = TextEditingController();
//   String? _imagePath;
//   var avatar;

//   // Function to open the image picker
//   // Future<void> _pickImage() async {
//   //   final pickedFile =
//   //       await ImagePicker().getImage(source: ImageSource.gallery);

//   //   //_image là 1 File ảnh chưa đường dẫn. Ví dụ _image == File: '/data/user/0/
//   //   _image = File(pickedFile!.path);
//   //   _imagePath = await uploadImage(_image!);
//   //   print('ppppppppp: $_imagePath');

//   //   setState(() {});
//   // }

//   // Function to post the new content
//   // void _post() {
//   //   // Example: Print the caption and reset the state
//   //   print('Caption: ${_captionController.text}');

//   //   //gọi đến api
//   //   print('test path Image: $_imagePath');
//   //   addPost(_captionController.text.toString(), _imagePath!);
//   //   setState(() {
//   //     _image = null;
//   //     _captionController.clear();
//   //   });
//   // }

//   Future<void> _pickImages() async {
//   final pickedFiles = await ImagePicker().pickMultiImage();

//   if (pickedFiles != null && pickedFiles.isNotEmpty) {
//     _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
//     setState(() {});
//   }
// }

//   void _post() async {
//     print('Caption: ${_captionController.text}');

//     // Gọi đến API và xử lý danh sách ảnh
//     for (var image in _images) {
//       var imagePath = await uploadImage(image);
//       addPost(_captionController.text.toString(), imagePath);
//     }

//     // Cập nhật UI
//     setState(() {
//       _images.clear();
//       _captionController.clear();
//     });
//   }

//   Future<void> openHiveBox() async {
//     var userBox = await Hive.openBox('userBox');
//     var centerBox = await Hive.openBox('centerBox');

//     var currentUser = userBox.get('currentUser');
//     var currentCenter = centerBox.get('currentCenter');

//     avatar = currentUser != null ? currentUser.avatar : currentCenter.avatar;
//     print('test avatar: $avatar');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: openHiveBox(),
//       builder: ((context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Row for avatar, username, and Post button
//                   Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                             border: Border.all(width: 4, color: Colors.white),

//                             //hiệu ứng bóng đổ
//                             boxShadow: [
//                               BoxShadow(
//                                   spreadRadius: 2,
//                                   blurRadius: 10,
//                                   color: Colors.black.withOpacity(0.1))
//                             ],
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage('$avatar'),
//                             )),
//                       ),
//                       const SizedBox(width: 8.0),
//                       const Text(
//                         'Username', // Replace with the actual username
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       ElevatedButton(
//                         onPressed: _post,
//                         child: const Text(
//                           'Post',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(
//                     height: 15,
//                   ),

//                   TextField(
//                     controller: _captionController,
//                     decoration: InputDecoration(
//                       hintText: 'Write a caption...',
//                       border: InputBorder.none,
//                       // Chỉnh đổi font chữ ở đây
//                       hintStyle: TextStyle(
//                           fontSize: 16.0,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.grey),
//                     ),
//                     maxLines: 2,
//                     // Chỉnh đổi font chữ cho nội dung đã nhập
//                     style: TextStyle(fontSize: 18.0, color: Colors.black),
//                   ),

//                   _image != null
//                       ? Image.file(
//                           _image!,
//                           height: 200,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         )
//                       : Container(
//                           height: 200.0,
//                           width: double.infinity,
//                           color: Colors.grey.shade300,
//                           child: Center(
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt),
//                               onPressed: _pickImage,
//                             ),
//                           ),
//                         ),
//                   SizedBox(height: 16.0),

//                   const SizedBox(
//                     height: 10,
//                   ),

//                   MaterialButton(
//                     minWidth: double.infinity,
//                     height: 60,
//                     color: Colors.blue,
//                     onPressed: () {
//                       print('test avatar from widget: $avatar');
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => FeedScreen()));
//                     },
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/services/image/upload_image_api.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<File> _images = [];
  final TextEditingController _captionController = TextEditingController();
  var avatar;

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      setState(() {});
    }
  }

  void _post() async {
    // Example: Print the caption and reset the state

    // Upload each image and get their paths
    List<String> imagePaths = [];
    for (var image in _images) {
      var imagePath = await uploadImage(image);
      imagePaths.add(imagePath);
    }

    // Call the API to post content with image paths
    addPost(_captionController.text.toString(), imagePaths);

    setState(() {
      _images = [];
      _captionController.clear();
    });
  }

  Future<void> openHiveBox() async {
    var userBox = await Hive.openBox('userBox');
    var centerBox = await Hive.openBox('centerBox');

    var currentUser = userBox.get('currentUser');
    var currentCenter = centerBox.get('currentCenter');

    avatar = currentUser != null ? currentUser.avatar : currentCenter.avatar;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openHiveBox(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
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
                            image: NetworkImage('$avatar'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _post,
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  _images.isNotEmpty
                      ? Column(
                          children: _images.map((image) {
                            return Image.file(
                              image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        )
                      : Container(
                          height: 200.0,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _pickImages,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 10),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
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
          );
        } else {
          return CircularProgressIndicator();
        }
      }),
    );
  }
}
