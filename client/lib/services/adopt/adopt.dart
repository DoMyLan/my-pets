import 'dart:convert';
import 'package:found_adoption_application/models/adopt.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<String> createAdopt(String petId, String descriptionAdoption) async {
  try {
    var body = jsonEncode(
        {'petId': petId, 'descriptionAdoption': descriptionAdoption});
    var responseData = await api('/adopt', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
      return responseData['id'];
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    // print(e.toString());
    notification("Adopt: ${e.toString()}", true);
  }
  return '';
}

Future<List<Adopt>> getStatusAdoptCenter(String status) async {
  var responseData;
  try {
    responseData = await api('/adopt/center?status=${status}', 'GET', '');

    if (responseData['success']) {
      var adoptList = responseData['data'] as List<dynamic>;
      List<Adopt> adopts =
          adoptList.map((json) => Adopt.fromJson(json)).toList();
      return adopts;
    }
  } catch (e) {
    // print(e);
    // notification(e.toString(), true);
  }
  // ignore: cast_from_null_always_fails
  return null as List<Adopt>;
}

Future<List<Adopt>> getStatusAdoptUser(String status) async {
  var responseData;
  try {
    responseData = await api('/adopt/user?status=${status}', 'GET', '');

    if (responseData['success']) {
      var adoptList = responseData['data'] as List<dynamic>;
      List<Adopt> adopts =
          adoptList.map((json) => Adopt.fromJson(json)).toList();
      return adopts;
    }
  } catch (e) {
    // print(e);
    // notification(e.toString(), true);
  }
  // ignore: cast_from_null_always_fails
  return null as List<Adopt>;
}

Future<void> changeStatusAdoptCenter(String adoptId, String statusAdopt) async {
  var responseData;
   var body = jsonEncode(
        {'statusAdopt': statusAdopt});
  try {
    responseData = await api('/adopt/${adoptId}/status', 'PUT', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
    }
  } catch (e) {
    // print(e);
    // notification(e.toString(), true);
  }
}

Future<void> changeStatusAdoptUser(String adoptId, String statusAdopt) async {
  var responseData;
   var body = jsonEncode(
        {'statusAdopt': statusAdopt});
  try {
    responseData = await api('/adopt/${adoptId}/status', 'PUT', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
    }
  } catch (e) {
    // print(e);
    // notification(e.toString(), true);
  }
}

