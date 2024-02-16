import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Thanh toán'),
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Địa chỉ nhận hàng',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 28.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.7, // Chiều rộng tối đa
                            child: Text(
                              '143/11 đường số 11, khu phố 9, phường Trường Thọ, Tp. Thủ Đức, Tp. Hồ Chí Minh',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            0), // Điều chỉnh lề bên trái và bên phải của Divider
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 5,
                      height: 30,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        'Trung tâm thú cưng Miami',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text('View Center'),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  color: Color.fromARGB(255, 248, 245, 245),
                  child: Row(
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300],
                        ),
                        // Placeholder for pet image
                        child: Image.asset('assets/images/Lan.jpg'),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sữa VinaMilk',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Breed: Mèo Anh lông ngắn',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Price: 235000 đ',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Icon(Icons.wallet_giftcard,
                        color: Color.fromARGB(255, 209, 191, 28)),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Voucher của Center',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Nhập mã voucher',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                      ),
                      onPressed: () {},
                      child: Text('Áp dụng', style: TextStyle(fontSize: 13, color: Colors.white),),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tin nhắn: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Lưu ý cho Trung tâm...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey.shade400)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 10,
                  height: 1,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Phương thức thanh toán (Nhấn để chọn)',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 99, 182, 124),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Color.fromARGB(255, 209, 191, 28),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Chi tiết thanh toán',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền hàng',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '235000 đ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền phí vận chuyển',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '40000 đ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền hàng',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '275000 đ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                // Divider(
                //   color: Colors.grey.shade300,
                //   thickness: 1,
                //   height: 1,
                // ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0,
                        3), // Thay đổi offset để điều chỉnh vị trí của bóng đổ
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        'Tổng thanh toán',
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '275000 đ',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // Xử lý sự kiện khi nhấn vào nút Đặt hàng
                    },
                    child: Container(
                      color: Colors.red,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: TextButton(
                          child: Text(
                            'Đặt hàng',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
