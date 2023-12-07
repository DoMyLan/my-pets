import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> centerform(BuildContext context, String name, String phoneNumber,
    String address, String aboutMe) async {
  final accountRegisterBox = await Hive.openBox('accountRegisterBox');
  final storedAccount = accountRegisterBox.get('account');
  try {
    final apiUrl =
        Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/center/${storedAccount}");
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'aboutMe': aboutMe
      }),
    );
    var responseData = json.decode(response.body);;

    if (responseData['success']) {
      notification(responseData['message'], false);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
  }
}
