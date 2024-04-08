import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/user_view_card_image.dart';
import 'package:found_adoption_application/models/review.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatefulWidget {
  final Review review;
  const UserReviewCard({super.key, required this.review});

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  bool isExpanded = false;
  Review get review => widget.review;

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
              '${review.petId.namePet} - ${review.petId.breed}, ${AgePet.convertAge(review.petId.birthday!)} tuổi - ${review.petId.weight} kg',
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

        _buildImages(review.images as List<dynamic>),

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
                  width: MediaQuery.of(context).size.width * 0.85,
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

  Widget _buildImages(List<dynamic> urls) {
    List<Widget> imageWidgets = [];
    int maxTotalImages = 4; // Số ảnh tối đa cần hiển thị
    int displayedImages = 0; // Số ảnh đã hiển thị

    for (int i = 0; i < urls.length && displayedImages < maxTotalImages; i++) {
      imageWidgets.add(
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FullScreenDialogImage(urls: urls, initialIndex: i, review: review,);
              },
            );
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Image.network(
                  urls[i],
                  width: 170, // Đặt chiều rộng cố định cho ảnh
                  height: 170, // Đặt chiều cao cố định cho ảnh
                  fit: BoxFit.cover,
                ),
                if (i == maxTotalImages - 1)
                  // Hiển thị Text '+1' trên ảnh thứ 4 nếu đã hiển thị đủ 5 ảnh
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text(
                          '+1',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
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
      children: imageWidgets,
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
