import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://www.thukieng.com/wp-content/uploads/2016/03/gia-mua-ban-meo-xiem-4.jpg'),
                ),
                SizedBox(width: 20, height: 20),
                Text('Trung tâm thú cưng',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                    'https://www.thukieng.com/wp-content/uploads/2016/03/gia-mua-ban-meo-xiem-4.jpg',
                    scale: 1.0,
                  ),
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ổ Khóa Cửa Cầu Dài Full Size 170mm và 11...',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'TỔNG 17CM CÀNG 13CM',
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '₫150.000',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₫99.000',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Colors.red,
                  thickness: 0.5,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// class ProductPage extends StatefulWidget {
//   const ProductPage({super.key});

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Thiết Bị Tiến Phát'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.favorite),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // Hình ảnh sản phẩm
//             Image.network(
//               'https://www.thukieng.com/wp-content/uploads/2016/03/gia-mua-ban-meo-xiem-4.jpg',
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Ổ Khóa Cửa Cầu Dài Full Size 170mm và 11...',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'TỔNG 17CM CÀNG 13CM',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(height: 8.0),

//                   // Giá sản phẩm
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         '₫150.000',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '₫99.000',
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Số lượng sản phẩm
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//               child: Row(
//                 children: <Widget>[
//                   Text('Số lượng:'),
//                   SizedBox(width: 8.0),
//                   Text('2'),
//                 ],
//               ),
//             ),

//             // Thanh toán
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text('Thanh toán'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Đánh giá sản phẩm
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: <Widget>[
//                   Text('Đánh giá sản phẩm trước 07-03-2024 nhé'),
//                   SizedBox(width: 8.0),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text('Đánh giá'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

