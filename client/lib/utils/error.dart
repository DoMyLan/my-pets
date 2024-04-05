import 'package:flutter/material.dart';

class errorWidget extends StatelessWidget {
  const errorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 100,
            color: Colors.red[400],
          ),
          Text(
            'Ôi không, đã có 1 chút lỗi nhỏ xảy ra',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Bạn vui lòng thử lại sau nhé hoặc chờ chúng tôi khắc phục sau',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
