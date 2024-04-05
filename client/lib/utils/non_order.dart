import 'package:flutter/material.dart';

class NonOrderWidget extends StatelessWidget {
  const NonOrderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shopping_cart,
            size: 100,
            color: Colors.grey[400],
          ),
          Text(
            'Không có đơn hàng',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[400],
            ),
          ),
          Text(
            'Hãy thêm một số sản phẩm vào giỏ hàng của bạn',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}