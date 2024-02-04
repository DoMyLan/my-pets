import 'package:flutter/material.dart';

Future<void> Loading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(0, 249, 248, 248),
        child: new Container(
          width: 50.0,
          height: 50.0,
          child: new Center(
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
