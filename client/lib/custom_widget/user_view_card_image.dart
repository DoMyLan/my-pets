import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';

class FullScreenDialogImage extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const FullScreenDialogImage({  required this.urls, required this.initialIndex}) ;

  @override
  State<FullScreenDialogImage> createState() => _FullScreenDialogImageState();
}

class _FullScreenDialogImageState extends State<FullScreenDialogImage> {

  late int currentIndex;

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
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      '${currentIndex + 1}/${widget.urls.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 48.0), // Để giữ khoảng cách với mũi tên
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
                        fit: BoxFit.fill,
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
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đặng Văn Tuấn',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TRatingBar(rating: 3.5),
                        SizedBox(height: 8.0),
                        Text(
                          'Bunny - Corgi, 1 tháng tuổi - 3,4 kg',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Em nó nhận về rất đúng với mô tả, rất dễ thương ngoan ngoãn và mạnh khỏe.',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage('assets/images/Lan.jpg'),
                      ),

                      SizedBox(height: 30,),
                   
                      Icon(
                        FontAwesomeIcons.thumbsUp,
                        color: Colors.blue,
                        size: 20.0,
                      ),
                    
                      Text(
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
                padding: EdgeInsets.all(16.0),
                color: Colors.black,
                child: Text(
                  '23-08-2023 08:59',
                  textAlign: TextAlign.start,
                  style: TextStyle(
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