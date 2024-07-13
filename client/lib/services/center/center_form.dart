import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> centerform(BuildContext context, String name, String phoneNumber,
    String address, String aboutMe, LatLng location) async {
  final accountRegisterBox = await Hive.openBox('accountRegisterBox');
  final storedAccount = accountRegisterBox.get('account');
  try {
    final apiUrl = Uri.parse(
        "$BASE_URL/center/${storedAccount}");
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'aboutMe': aboutMe,
        'location': {
          'latitude': 10.7871821,
          'longitude': 106.6160642
        },
      }),
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      notification("Success!", false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
  }
}
