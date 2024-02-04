import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/dialog_otp.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> signup(BuildContext context, String email, String password,
    String signupType) async {
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/sign-up");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': signupType, // Lựa chọn từ radio button
      }),
    );

    if (response.statusCode == 201) {
      final emailRegisterBox = await Hive.openBox('emailRegisterBox');
      emailRegisterBox.put('email', email);
      emailRegisterBox.put('role', signupType);
      // Xử lý thành công
      final responseData = json.decode(response.body);
      final accountRegisterBox = await Hive.openBox('accountRegisterBox');
      accountRegisterBox.put('account', responseData['account']);
      notification("Resgister successfully!", false);
      showOTPInputDialog(context);
    } else {
      final responseData = json.decode(response.body);
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}

Future<bool> verifycode(String email, String code) async {
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/verify-code");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
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
    //  notification(e.toString(), true);
    return false;
  }
}

Future<void> resendcode(String email) async {
  try {
    final apiUrl = Uri.parse(
        'https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/send-code');

    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}));

    if (response.statusCode == 200) {
      print('RESEND SUCCESS !');

      final responseData = jsonDecode(response.body);
      print('Resend success: ${responseData}');
    } else {
      print('RESEND FAIL');
    }
  } catch (e) {
    print(e);
  }
}
