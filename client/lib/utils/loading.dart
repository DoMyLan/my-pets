import 'package:flutter/material.dart';

Future<void> Loading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
