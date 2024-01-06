import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> userform(
    BuildContext context,
    String accountId,
    String firstName,
    String lastName,
    String phoneNumber,
    String address,
    bool experience,
    aboutMe) async {
  final accountRegisterBox = await Hive.openBox('accountRegisterBox');
  final storedAccount =
      accountId != '' ? accountId : accountRegisterBox.get('account');

  print(storedAccount);
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/user/${storedAccount}");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'experience': experience,
        'aboutMe': aboutMe
      }),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      notification("Success!", false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}
