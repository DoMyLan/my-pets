import 'dart:convert';

import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<bool> changePassword(String password, String newPassword) async {
  var responseData;
  var body = jsonEncode(
      <String, String>{'password': password, 'newPassword': newPassword});
  try {
    responseData = await api('/auth/change-password', 'PUT', body);
    // notification(responseData[], true);

    if (responseData['message'] == 'Password changed successfully!') {
      notification(responseData['message'], false);
      return true;
    } else {
      notification(responseData['message'], true);
      return false;
    }
  } catch (e) {
    print(e);
    // notification(e.toString(), true);
    return false;
  }
}
