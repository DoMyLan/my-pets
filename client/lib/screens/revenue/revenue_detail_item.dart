import 'package:flutter/material.dart';

class RevenueDetailScreen extends StatefulWidget {
  @override
  State<RevenueDetailScreen> createState() => _RevenueDetailScreenState();
}

class _RevenueDetailScreenState extends State<RevenueDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Chi tiết doanh thu'),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Color.fromRGBO(48, 96, 96, 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đơn hàng đã hoàn thành',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Đã thanh toán cho Người bán',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        'Hoàn tất chuyển khoản vào 15 Th08 2023',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //MÃ ĐƠN HÀNG
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mã đơn hàng',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(
                        '230815DRSSYVX',
                        style: TextStyle(fontSize: 15),
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //TỔNG TIỀN SẢN PHẨM
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng tiền hàng',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('đ 429.000')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Giá sản phẩm', style: TextStyle(fontSize: 15)),
                      Text('đ 429.000')
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //KHUYẾN MÃI
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Khuyến mãi',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('10%')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trị giá khuyến mãi', style: TextStyle(fontSize: 15)),
                      Text('đ 29.000')
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //PHÍ VẬN CHUYỂN
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('đ 0')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển Người mua trả',
                          style: TextStyle(fontSize: 15)),
                      Text('đ 9.000')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển Trung tâm trợ giá',
                          style: TextStyle(fontSize: 15)),
                      Text('đ 10.000')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển thực tế',
                          style: TextStyle(fontSize: 15)),
                      Text('đ 19.000')
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            //DOANH THU
            Container(
              padding: EdgeInsets.all(8),
              width: widthDevice,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Doanh thu',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('đ 390.000')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

