import 'package:flutter/material.dart';

Widget inputField(
    {String? label,
    bool obscureText = false,
    TextEditingController? controller,
    bool? isPassword,
    bool? isLogin}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label ?? '',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: isPassword! ? obscureText : false,
        onChanged: (value) => isPassword! ? validatePassword(value) : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          errorText: isLogin!
              ? null
              : (isPassword! ? validatePassword(controller!.text) : null),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}

String? validatePassword(String value) {
  Pattern pattern = r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$';
  RegExp regex = new RegExp(pattern as String);
  if (!regex.hasMatch(value))
    return 'Password must have at least 8 characters, include \nuppercase, lowercase and number';
  else
    return null;
}
