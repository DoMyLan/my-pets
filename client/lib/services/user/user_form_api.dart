import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> userform(
    BuildContext context,
    String accountId,
    String firstName,
    String lastName,
    String phoneNumber,
    String address,
    LatLng location,
    bool experience,
    aboutMe) async {
  final accountRegisterBox = await Hive.openBox('accountRegisterBox');
  final storedAccount =
      accountId != '' ? accountId : accountRegisterBox.get('account');
  try {
    final apiUrl = Uri.parse("$BASE_URL/user/$storedAccount");

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
        'location': {
          'latitude': 10.8508873,
          'longitude': 106.755526
        },
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
