import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/testRating.dart';

class AddFeedBackScreen extends StatefulWidget {
  @override
  State<AddFeedBackScreen> createState() => _AddFeedBackScreenState();
}

class _AddFeedBackScreenState extends State<AddFeedBackScreen> {
  bool switchValue = true;
  late double currentRating = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(48, 96, 96, 1.0)),
          onPressed: () {
            Navigator.pop(
                context); 
          },
        ),
        title: Text('Đánh giá sản phẩm'),
        actions: [
          TextButton(
            onPressed: () {
              // Xử lý khi nhấn vào nút Gửi
            },
            child: Text(
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
                        child: Icon(Icons.image, size: 60, color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trung tâm Miami',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Phân loại: Bunny - Corgi, 1 tháng tuổi - 3.4kg',
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
                      TRatingBar(
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt,
                                size: 30,
                                color: Color.fromRGBO(48, 96, 96, 1.0)),
                            SizedBox(height: 5),
                            Text(
                              'Thêm hình ảnh',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(48, 96, 96, 1.0)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        width: MediaQuery.of(context).size.width * 0.44,
                        child: Column(
                          children: [
                            Icon(Icons.video_camera_back,
                                size: 30,
                                color: Color.fromRGBO(48, 96, 96, 1.0)),
                            SizedBox(height: 5),
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
                    height: 20,
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
                              'Tên tài khoản của bạn sẽ hiển thị như Đặng Văn Tuấn',
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

void main() {
  runApp(MaterialApp(
    home: AddFeedBackScreen(),
  ));
}
