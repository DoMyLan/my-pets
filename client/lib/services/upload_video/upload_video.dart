import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:http/http.dart' as http;

Future<String> createAudioUpload(String fileUrl) async {
  try {
    var userBox = await Hive.openBox('userBox');
    var currentUser = userBox.get('currentUser');
    var centerBox = await Hive.openBox('centerBox');
    var currentCenter = centerBox.get('currentCenter');
    var currentClient = currentUser != null && currentUser.role == 'USER'
        ? currentUser
        : currentCenter;
    var accessToken = currentClient.accessToken;

    var responseData = {};

    final apiUrl = Uri.parse("$BASE_URL/upload/video");

    var request = http.MultipartRequest('POST', apiUrl)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromPath('file', fileUrl,
          contentType: MediaType('audio', 'mp4')));

    final response = await request.send();
    var responseBody = await response.stream.bytesToString();

    responseData = json.decode(responseBody);
    return responseData['url'];
  } catch (e) {
    // notification(e.toString(), true);
    print('error: $e');
  }

  return '';
}
