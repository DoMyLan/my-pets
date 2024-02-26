// import 'package:flutter/material.dart';

// class Orders extends StatefulWidget {
//   const Orders({super.key});
//   @override
//   State<Orders> createState() => _OrdersState();
// }

// class _OrdersState extends State<Orders> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Orders'),
//       ),
//       body: Material(
//         child: Container(
//           child: Column(
//             children: <Widget>[
//               const Text('Orders'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết Bị Tiến Phát'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Hình ảnh sản phẩm
            Image.asset(
              'assets/images/product_image.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),

            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ổ Khóa Cửa Cầu Dài Full Size 170mm và 11...',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'TỔNG 17CM CÀNG 13CM',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8.0),

                  // Giá sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '₫150.000',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₫99.000',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Số lượng sản phẩm
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                children: <Widget>[
                  Text('Số lượng:'),
                  SizedBox(width: 8.0),
                  Text('2'),
                ],
              ),
            ),

            // Thanh toán
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Thanh toán'),
                    ),
                  ),
                ],
              ),
            ),

            // Đánh giá sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text('Đánh giá sản phẩm trước 07-03-2024 nhé'),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {},
                    child: Text('Đánh giá'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

