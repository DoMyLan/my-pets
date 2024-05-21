import 'package:flutter/material.dart';

class OnPressedButton extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const OnPressedButton({super.key, required this.size, required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
