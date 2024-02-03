import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/dialog_otp.dart';
import 'package:found_adoption_application/models/current_center.dart';
import 'package:found_adoption_application/models/current_location.dart';
import 'package:found_adoption_application/models/current_user.dart';

import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/register_form.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/registration_form.dart';
import 'package:found_adoption_application/services/auth/signup_api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
  var responseData;
  var body = jsonEncode(<String, String>{'email': email, 'password': password});
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/sign-in");
    var response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['data']['role'] == 'USER') {
        var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở
        var user = User()
          ..id = responseData['data']['_id']
          ..accountId = responseData['data']['accountId']
          ..email = responseData['data']['email']
          ..role = responseData['data']['role']
          ..status = responseData['data']['status']
          ..firstName = responseData['data']['firstName']
          ..lastName = responseData['data']['lastName']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..avatar = responseData['data']['avatar']
          ..address = responseData['data']['address']
          ..location = CurrentLocation(
            latitude: responseData['data']['location']['latitude'],
            longitude: responseData['data']['location']['longitude'],
          )
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await userBox.put('currentUser', user);
        await userBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedUser =
            userBox.get('currentUser'); // Lấy thông tin User từ Hive

        notification("Login user success!", false);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuFrameUser(
                      userId: retrievedUser.id,
                    )));
      } else if (responseData['data']['role'] == 'CENTER') {
        var centerBox = await Hive.openBox('centerBox'); // Lấy Hive box đã mở
        var currentCenter = CurrentCenter()
          ..id = responseData['data']['_id']
          ..accountId = responseData['data']['accountId']
          ..email = responseData['data']['email']
          ..role = responseData['data']['role']
          ..status = responseData['data']['status']
          ..name = responseData['data']['name']
          ..avatar = responseData['data']['avatar']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..address = responseData['data']['address']
          ..location = CurrentLocation(
            latitude: responseData['data']['location']['latitude'],
            longitude: responseData['data']['location']['longitude'],
          )
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await centerBox.put('currentCenter', currentCenter);
        await centerBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedCenter =
            centerBox.get('currentCenter'); // Lấy thông tin User từ Hive

        notification("Login center success!", false);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MenuFrameCenter(centerId: retrievedCenter.id)));
      } else if (responseData['data']['role'] == 'ADMIN') {
        Navigator.pop(context);
        notification('You is ADMIN!', true);
      }
    } else if (responseData['message'] == 'Account is not active!') {
      Navigator.pop(context);
      notification(responseData['message'], true);
      _showLogoutDialog(context, email);
    } else if (responseData['message'] == 'User information not found!') {
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RegistrationForm(accountId: responseData['id'])));

      notification(responseData['message'], true);
    } else if (responseData['message'] == 'Center information not found!') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegistrationCenterForm()));
    } else {
      Navigator.pop(context);
      notification(responseData['message'], true);
      print(responseData);
    }
  } catch (e) {
    print(e);

    if (e.toString() ==
        "ClientException with SocketException: Failed host lookup: 'found-and-adoption-pet-api-be.vercel.app' (OS Error: No address associated with hostname, errno = 7), uri=https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/sign-in") {
      Navigator.pop(context);
      notification("Check your Network and Try again.", true);
    }
  }
}

Future<bool> forgotPassword(String email) async {
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/forgot-password");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      notification(responseData['message'], false);
      return true;
    } else {
      final responseData = json.decode(response.body);
      notification(responseData['message'], true);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<void> _showLogoutDialog(BuildContext context, String email) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Notice'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Account is not active! You are continue?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Continue'),
            onPressed: () async {
              Navigator.of(context).pop();
              resendcode(email);
              //Navigate
              showOTPInputDialog(context);
            },
          ),
        ],
      );
    },
  );
}
