import 'dart:convert';
import 'package:found_adoption_application/services/api.dart';

Future<String> follow_unfollow(String? userId, String? centerId) async {
  var responseData = {};
  try {
    var json = jsonEncode({
      "userId": userId,
      "centerId": centerId,
    });
    responseData = await api('follow', 'POST', json);
    var message = responseData['message'];
    return message;
  } catch (e) {
    // notification(e.toString(), true);
    return 'error';
  }
}

Future<List<String>> getFollowCenter() async {
  var responseData = {};
  try {
    responseData = await api('follow/center', 'GET', '');
    var followList = responseData['data'] as List<dynamic>;
    List<String> follows = followList.map((json) => json.toString()).toList();
    return follows;
  } catch (e) {
    // notification(e.toString(), true);
    return [];
  }
}
