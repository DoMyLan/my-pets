import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<String> refreshAccessToken() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở
  var centerBox = await Hive.openBox('centerBox');

  var currentUser = userBox.get('currentUser');
  var currentCenter = centerBox.get('currentCenter');

  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;

  // final refreshToken = userBox.get('currentUser').refreshToken;
  final refreshToken = currentClient.refreshToken;
  final apiUrl = Uri.parse(
      "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/refresh-token");

  final response = await http.post(apiUrl, headers: {
    'Authorization': 'Bearer ${refreshToken}',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final newAccessToken = responseData['accessToken'];

    if (currentClient.role == 'USER') {
      currentUser.accessToken = newAccessToken;
      userBox.put('currentUser', currentUser);
    } else {
      currentCenter.accessToken = newAccessToken;
      centerBox.put('currentCenter', currentCenter);
    }
    return newAccessToken;
  } else {
    var userBox = await Hive.openBox('userBox');
    await userBox.put('currentUser', null);

    var centerBox = await Hive.openBox('centerBox');
    await centerBox.put('currentCenter', null);
    // ignore: use_build_context_synchronously
    Navigator.push(navigatorKey.currentState!.context,
        MaterialPageRoute(builder: ((context) => LoginScreen())));
    notification("The login session has expired, please log in again!", false);

    return 'Login';
  }
}
