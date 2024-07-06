import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/user_view_card_image.dart';
import 'package:found_adoption_application/models/review.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class UserReviewCard extends StatefulWidget {
  final Review review;
  const UserReviewCard({super.key, required this.review});

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  bool isExpanded = false;
  Review get review => widget.review;

  //video
  late VideoPlayerController? _controller;
  bool _isVideoLoaded = false;
  bool _isPlaying = false;
  List<Widget?> urls = [];

  @override
  void initState() {
    super.initState();
    if (widget.review.video != null && widget.review.video!.isNotEmpty) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.review.video!))
            ..initialize().then((_) {
              setState(() {
                _isVideoLoaded = true;
              });
            });
    }
    // else if (widget.review.images != null &&
    //     widget.review.images!.isNotEmpty) {
    //   urls = widget.review.images!.map((url) => Image.network(url)).toList();
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    urls = [];
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        //Thông tin nhanh về Pet

        //Phần bình luận của ng mua
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.buyer.avatar),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '${review.buyer.firstName} ${review.buyer.lastName}',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                // Mở đến bài đăng về pet đã bán
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade700,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Màu của bóng đổ
                      spreadRadius: 2, // Khoảng lan rộng của bóng đổ
                      blurRadius: 5, // Độ mờ của bóng đổ
                      offset: const Offset(0, 3), // Độ lệch của bóng đổ
                    ),
                  ],
                ),
                child: const Text(
                  'Xem chi tiết bài đăng', // Văn bản trong thẻ
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.white, // Màu cho văn bản
                    fontWeight: FontWeight.bold, // In đậm cho văn bản
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            TRatingBar(rating: double.parse(review.rating.toString())),
            const SizedBox(
              width: 10,
            ),
            Text(
              DateFormat('dd/MM/yyyy | HH:mm:ss').format(review.createdAt),
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          children: [
            const Text(
              'Phân loại: ',
              style: TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '${review.petId.namePet} - ${review.petId.breed}, ${AgePet.convertAge(review.petId.birthday!)} tuổi - ${review.petId.weight}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ReadMoreText(
            review.comment,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimExpandedText: '...Ẩn bớt',
            trimCollapsedText: '...Xem thêm',
            moreStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            lessStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 3,
        ),

        //list image

        _buildImages(review.images as List<dynamic>, review.video ?? ''),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.createdAt.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            Row(children: [
              const Text(
                'Phản hồi của người bán',
                style: TextStyle(fontSize: 12),
              ),

              // Icon(Icons.arrow_drop_down)
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                    isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up),
              )
            ])
          ],
        ),

        ...(!isExpanded
            ? [
                Container(
                  width: deviceWidth * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.seller.centerId != null
                            ? review.seller.centerId!.name
                            : review.seller.userId!.firstName +
                                review.seller.userId!.lastName,
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        'Cảm ơn sự tin tưởng của bạn, đây sẽ là động lực cho chúng tôi phát triển chất lượng phục vụ sau này!',
                        style: TextStyle(
                            fontSize: 12.5, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]
            : []),

        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 10,
            height: 1,
          ),
        ),
      ],
    );
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
      setState(() {
        _isPlaying = false;
      });
    } else if (_controller != null) {
      _controller!.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Widget _buildImages(List<dynamic> urls, String video) {
    List<Widget?> imageWidgets = [];
    int maxTotalImages = 4; // Số ảnh tối đa cần hiển thị
    int displayedImages = 0; // Số ảnh đã hiển thị
    bool isVideoDisplayed = false;

   

    if (!isVideoDisplayed && video.isNotEmpty) {
      // Nếu có video, thêm video vào danh sách ảnh đầu tiên
      imageWidgets.add(SizedBox(
        width: 140,
        height: 140,
        child: AspectRatio(
          aspectRatio: 16 / 9, // Aspect ratio của video
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller!),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                color: Colors.white,
                iconSize: 50,
              ),
            ],
          ),
        ),
      ));
      displayedImages++;
      isVideoDisplayed = true;
    } 
      for (int i = 0;
          i < urls.length && displayedImages < maxTotalImages;
          i++) {
        // Thêm ảnh vào danh sách
        imageWidgets.add(
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FullScreenDialogImage(
                    urls: urls,
                    initialIndex: i,
                    review: review,
                  );
                },
              );
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                urls[i],
                width: 170, // Đặt chiều rộng cố định cho ảnh
                height: 170, // Đặt chiều cao cố định cho ảnh
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
        displayedImages++;
      }
    

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2, // Chia mỗi hàng thành 2 cột
      mainAxisSpacing: 4.0, // Khoảng cách giữa các hàng
      crossAxisSpacing: 4.0, // Khoảng cách giữa các cột
      children: imageWidgets
          .where((element) => element != null)
          .whereType<Widget>()
          .toList(), // Lọc bỏ các phần tử null
    );
  }
}

class AgePet {
  static String convertAge(DateTime birthday) {
    String age = '';
    DateTime now = DateTime.now();
    int months = now.month - birthday.month + 12 * (now.year - birthday.year);
    if (now.day < birthday.day) {
      months--;
    }

    if (months < 1) {
      // If age is less than 1 month, calculate in weeks
      int weeks = (now.difference(birthday).inDays / 7).floor();
      age = '$weeks tuần';
    } else if (months < 12) {
      // If age is less than 1 year, calculate in months
      age = '$months tháng';
    } else {
      // If age is 1 year or more, calculate in years and months
      int years = months ~/ 12;
      months %= 12;
      age = '$years năm $months tháng';
    }

    return age;
  }
}
