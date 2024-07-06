import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFirstOrderIcon extends StatefulWidget {
  final int notificationCount;

  const CustomFirstOrderIcon({
    Key? key,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  State<CustomFirstOrderIcon> createState() => _CustomFirstOrderIconState();
}

class _CustomFirstOrderIconState extends State<CustomFirstOrderIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
  alignment: Alignment.center,
  children: [
    Container(
      width: 38,
      height: 46,
      child: Icon(FontAwesomeIcons.shoppingCart, size: 30)), // Đặt kích thước của biểu tượng Icon
    if (widget.notificationCount > 0)
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Text(
            '${widget.notificationCount}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
  ],
);


  }
}
