import 'dart:convert';
import 'dart:io';
import 'package:found_adoption_application/services/auth_api.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<String> uploadImage(File image) async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var centerBox = await Hive.openBox('centerBox');
  var currentCenter = centerBox.get('currentCenter');
  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;
  var accessToken = currentClient.accessToken;

  var responseData = {};

  try {
    final apiUrl = Uri.parse("$BASE_URL/upload/single");

    var request = http.MultipartRequest('POST', apiUrl)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    responseData = json.decode(responseBody);

    if (responseData['message'] == 'jwt expired') {
      var newAccessToken = refreshAccessToken().toString();
      currentClient.accessToken = newAccessToken;

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      var request = http.MultipartRequest('POST', apiUrl)
        ..headers['Authorization'] = 'Bearer $newAccessToken'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();
      responseBody = await response.stream.bytesToString();
      responseData = json.decode(responseBody);
      return responseData['url'];
    }
    return responseData['url'];
  } catch (e) {
    // notification(e.toString(), true);
    return '';
  }
}
