import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart'
    as reviewRating;
import 'package:found_adoption_application/screens/testRating.dart'
    as testRating;
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/services/post/review.dart';
import 'package:found_adoption_application/services/upload_video/upload_video.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddFeedBackScreen extends StatefulWidget {
  final Order order;
  AddFeedBackScreen({required this.order});

  @override
  State<AddFeedBackScreen> createState() => _AddFeedBackScreenState();
}

class _AddFeedBackScreenState extends State<AddFeedBackScreen> {
  int currentIndex = 0;
  final ImagePicker imagePicker = ImagePicker();
  final CarouselController carouselController = CarouselController();
  List<XFile> imageFileList = [];
  List<dynamic> finalResult = [];
  Order? order;

  late String videoPath = '';

  TextEditingController _commentController = TextEditingController();

  //video
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false;
  bool _isPlaying = false;

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
        print('object');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    order = widget.order;
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
    _commentController.clear();
    finalResult.clear();
    videoPath = '';
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
        videoPath = result.files.single.path!;
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

  bool switchValue = true;
  late double currentRating = 4;

  Future<void> postFeedBack() async {
    // print('test images here: $finalResult');

    // Kiểm tra trạng thái mounted trước khi gọi setState
    if (mounted) {
      await addReview(
          widget.order.buyer.id.toString(),
          widget.order.seller.typeSeller.toString(),
          // widget.order.seller.centerId.toString(),
          // 'abc',
          widget.order.seller.centerId!.id.toString(),
          widget.order.petId.id.toString(),
          currentRating.toInt(),
          _commentController.text.toString(),
          finalResult.toList(),
          videoPath,
          order!.id);
    }
    setState(() {
      imageFileList = [];
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(48, 96, 96, 1.0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Đánh giá sản phẩm'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_commentController.text.toString() == "") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Thông báo'),
                      content: const Text(
                          'Bạn chưa cho chúng tôi biết cảm nhận của bạn về thú cưng!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đóng'),
                        ),
                      ],
                    );
                  },
                );
                return;
              } else {
                Loading(context);
                await postFeedBack();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => reviewRating.ReviewProfileScreen(
                      centerId: widget.order.seller.centerId!.id,
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Gửi',
              style: TextStyle(
                color: Color.fromRGBO(48, 96, 96, 1.0),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: Color.fromARGB(255, 241, 241, 233),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      FontAwesomeIcons.moneyBill1Wave,
                      size: 30,
                      color: Color.fromRGBO(48, 96, 96, 1.0),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Đánh giá và nhận ngay Voucher lên đến ',
                          ),
                          TextSpan(
                            text: '30%',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(48, 96, 96, 1.0),
                              fontWeight:
                                  FontWeight.bold, // In đậm văn bản phần 30%
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hàng 1: Hình ảnh và 2 Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        // Thay thế bằng hình ảnh thực tế tại đây
                        // child: Icon(Icons.image, size: 60, color: Colors.white),

                        child: Image(
                          height: 60,
                          width: double.infinity,
                          image: NetworkImage(widget.order.petId.images.first),
                          fit: BoxFit.cover, //vấn đề ở đây nè nha
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.seller.centerId!.name.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Phân loại: ${widget.order.petId.petType} - ${widget.order.petId.breed} , ${widget.order.petId.namePet}  - ${widget.order.petId.price}',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: Divider(
                      color: Color.fromRGBO(48, 96, 96, 1.0),
                      thickness: 2,
                      height: 1,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.only(right: 10),
                          width: 100,
                          child: Text(
                            'Chất lượng sản phẩm',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )),
                      testRating.TRatingBar(
                        initialRating: currentRating, // Số sao ban đầu
                        onRatingChanged: (rating) {
                          currentRating = rating;
                          print('currentRating: $currentRating');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Add IMAGE & VIDEO
                  Text(
                    'Thêm 50 ký tự và 5 hình ảnh và 1 video để mang lại đánh giá tổng quan nhất',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (imageFileList.isNotEmpty)
                        if (imageFileList.length == 1)
                          Image.file(
                            File(imageFileList[0].path),
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                              height: 140,
                              width: 140,
                              child: _slider(finalResult))
                      else
                        Container(
                          height: 90,
                          width: 150,
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  color: Color.fromRGBO(48, 96, 96, 1.0),
                                  onPressed: selectImage),
                              Text(
                                'Thêm hình ảnh',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(48, 96, 96, 1.0)),
                              ),
                            ],
                          ),
                        ),
                      _isVideoLoaded
                          ? Container(
                              width: 140,
                              height: 140,
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
                            )
                          : Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              width: 150,
                              height: 90,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.video_camera_back,
                                        size: 32,
                                        color: Color.fromRGBO(48, 96, 96, 1.0)),
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
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Phần đánh giá
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey.shade100,
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          hintMaxLines: 7,
                          border: InputBorder.none,
                          hintText:
                              'Hãy chia sẻ nhận xét để Trung tâm cải thiện và mang lại chất lượng phục vụ tốt nhất bạn nhé!',
                          hintStyle: TextStyle(
                              fontSize: 16, color: Colors.grey.shade400)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Hiển thị Tên
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hiển thị tên đăng nhập trên đánh giá này',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),

                            //chỗ này get tên user thật vào
                            Text(
                              'Tên tài khoản của bạn sẽ hiển thị như ${widget.order.buyer.firstName} ${widget.order.buyer.lastName}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: switchValue,
                        onChanged: (newValue) {
                          // Xử lý khi giá trị của nút chuyển đổi thay đổi
                          setState(() {
                            switchValue = newValue;
                          });
                        },
                        activeColor: Colors.blue, // Màu của nút khi được bật
                        inactiveTrackColor:
                            Colors.grey, // Màu của vùng nền khi nút được tắt
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  width: 200,
                ),
              )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: 30 / 30,
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
                  height: 2.0,
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

  Widget getTextFromRating(double rating) {
    String text;
    switch (rating) {
      case 1:
        text = 'Tệ';
        break;
      case 2:
        text = 'Không hài lòng';
        break;
      case 3:
        text = 'Bình thường';
        break;
      case 4:
        text = 'Hài lòng';
        break;
      case 5:
        text = 'Tuyệt vời';
        break;
      default:
        text = '';
    }
    return Text(text);
  }
}
