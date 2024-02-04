import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<InfoUser> getProfile(BuildContext context, var userId) async {
  var currentClient = await getCurrentClient();
  var id = userId != null ? userId : currentClient.id;
  var user;
  var responseData;
  try {
    responseData = await api('/user/${id}', 'GET', '');
    var userData = responseData['data'];
    user = InfoUser.fromJson(userData);
  } catch (e) {
    // notification(e.toString(), true);
  }
  return user;
}

Future<void> updateProfile(BuildContext context, firstName, lastName,
    phoneNumber, address, experience, aboutMe) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var responseData;
  var body = jsonEncode(<String, dynamic>{
    if (firstName != "") 'firstName': firstName,
    if (lastName != "") 'lastName': lastName,
    if (phoneNumber != "") 'phoneNumber': phoneNumber,
    if (address != "") 'address': address,
    'experience': experience,
    if (aboutMe != "") 'aboutMe': aboutMe,
  });
  try {
    if (body == jsonEncode(<String, String>{})) {
      notification('No something change!', false);
      return;
    }
    responseData = await api('/user/${id}', 'PUT', body);
    notification(responseData['message'], false);
  } catch (e) {
    // notification(e.toString(), true);
  }
}

Future<InfoCenter> getProfileCenter(BuildContext context, var centerId) async {
  var currentClient = await getCurrentClient();
  var id = centerId != null ? centerId : currentClient.id;
  var center;
  try {
    var responseData;
    responseData = await api('/center/${id}', 'GET', '');
    var centerData = responseData['data'] as dynamic;
    center = InfoCenter.fromJson(centerData);
  } catch (e) {
    // notification(e.toString(), true);
  }
  return center;
}

Future<void> updateProfileCenter(
    BuildContext context, name, phoneNumber, address) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var responseData;
  var body = jsonEncode(<String, String>{
    if (name != "") 'name': name,
    if (phoneNumber != "") 'phoneNumber': phoneNumber,
    if (address != "") 'address': address
  });
  try {
    if (body == jsonEncode(<String, String>{})) {
      notification('No something change!', false);
      return;
    }
    responseData = await api('/center/${id}', 'PUT', body);
    notification('Updated successfully!', false);
  } catch (e) {
    // notification(e.toString(), true);
  }
}

Future<void> changeStatus(BuildContext context, userId, status) async {
  var responseData;
  var body = jsonEncode(<String, String>{
    'status': status,
  });
  try {
    responseData = await api('/user/${userId}/status', 'PUT', body);
    notification(responseData['message'], false);
  } catch (e) {
    // notification(e.toString(), true);
  }
}
