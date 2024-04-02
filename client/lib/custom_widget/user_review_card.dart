import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/user_view_card_image.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard({super.key});

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  final List<String> imageUrls = [
    'https://www.morganstanley.com/content/dam/msdotcom/ideas/pet-care/tw-pet-care.jpg',
    'https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2023/03/happy_dog_being_held_by_woman.jpeg.jpg',
    'https://static.foxbusiness.com/foxbusiness.com/content/uploads/2022/04/iStock-1324099927.jpg',
    'https://www.morganstanley.com/content/dam/msdotcom/ideas/pet-care/tw-pet-care.jpg',
    'https://www.morganstanley.com/content/dam/msdotcom/ideas/pet-care/tw-pet-care.jpg',
  ];
  bool isExpanded = false;
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
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Lan.jpg'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Đặng Văn Tuấn',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                // Mở đến bài đăng về pet đã bán               
              },
              child: Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade700, 
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(16.0), 
                    bottomRight: Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Màu của bóng đổ
                      spreadRadius: 2, // Khoảng lan rộng của bóng đổ
                      blurRadius: 5, // Độ mờ của bóng đổ
                      offset: Offset(0, 3), // Độ lệch của bóng đổ
                    ),
                  ],
                ),
                child: Text(
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
            const TRatingBar(rating: 4),
            const SizedBox(
              width: 10,
            ),
            Text(
              '22-08-2023 10:39',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          children: [
            Text(
              'Phân loại: ',
              style: TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'Bunny - Corgi, 1 tháng tuổi - 3,4 kg',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),
        ReadMoreText(
          'Em nó nhận về rất đúng với mô tả, rất dễ thương ngoan ngoãn và mạnh khỏe.',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: 'show less',
          trimCollapsedText: 'show more',
          moreStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          lessStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 3,
        ),

        //list image

        _buildImages(imageUrls),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '28-02-2024 20:32',
              style: TextStyle(fontSize: 12),
            ),
            Row(children: [
              Text(
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
                        'Trung tâm Miami',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        'Cảm ơn sự tin tưởng của bạn, đây sẽ là động lực cho chúng tôi phát triển chất lượng phục vụ sau này =))',
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
          padding: EdgeInsets.only(bottom: 10),
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 10,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildImages(List<String> urls) {
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
                return FullScreenDialogImage(urls: urls, initialIndex: i);
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
                      child: Center(
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
