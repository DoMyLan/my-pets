import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/review.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:intl/intl.dart';

class FullScreenDialogImage extends StatefulWidget {
  final List<dynamic> urls;
  final Review review;
  final int initialIndex;
  const FullScreenDialogImage(
      {required this.urls, required this.initialIndex, required this.review});

  @override
  State<FullScreenDialogImage> createState() => _FullScreenDialogImageState();
}

class _FullScreenDialogImageState extends State<FullScreenDialogImage> {
  late int currentIndex;
  Review get review => widget.review;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: currentIndex);
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  '${currentIndex + 1}/${widget.urls.length}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 48.0), // Để giữ khoảng cách với mũi tên
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PageView.builder(
                itemCount: widget.urls.length,
                controller: pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    widget.urls[index],
                    fit: BoxFit.scaleDown,
                  );
                },
                onPageChanged: (int newIndex) {
                  // Cập nhật chỉ số hiện tại khi lướt sang trái hoặc phải
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
              ),
            ),
          ),

          //information
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${review.buyer.firstName} ${review.buyer.lastName}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TRatingBar(rating: double.parse(review.rating.toString())),
                    const SizedBox(height: 8.0),
                    Text(
                      '${review.petId.namePet} - ${review.petId.breed}, ${AgePet.convertAge(review.petId.birthday!)} tuổi - ${review.petId.weight} kg',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      review.comment,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(review.buyer.avatar),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Icon(
                    FontAwesomeIcons.thumbsUp,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                  const Text(
                    '4', // Số lượt thích
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              )
            ],
          ),
          //Thời gian đăng đánh giá
          // Phần thời gian
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black,
            child: Text(
              DateFormat('dd/MM/yyyy | HH:mm:ss').format(review.createdAt),
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
