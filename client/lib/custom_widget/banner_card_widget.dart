import 'package:flutter/material.dart';
import 'package:found_adoption_application/main.dart';

//tesst1234444
Widget bannerCard() {
  return Container(
    height: 255,
    width: 340,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 10,
      color: startingColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Welcome',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 27, color: Colors.white),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Find the best pet near you and adopt your favorite one',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 58),
        ],
      ),
    ),
  );
}
