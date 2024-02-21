import 'dart:convert';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<String>> uploadMultiImage(List<XFile> images) async {
  var responseData = {};

  try {
    final apiUrl = Uri.parse(
        "$BASE_URL/upload/multi-image");

    var request = http.MultipartRequest('POST', apiUrl);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

  List<XFile> imagesList=[];
  imagesList.addAll(images);
    for (var image in imagesList) {
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    responseData = json.decode(responseBody);

    List<String> urls = responseData['images']
        .map((item) => item['url'].toString())
        .toList()
        .cast<String>();
    return urls;
  } catch (e) {
    // notification(e.toString(), true);
    return [];
  }
}
