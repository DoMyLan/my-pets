import 'dart:convert';

import 'package:found_adoption_application/services/api.dart';

import 'package:found_adoption_application/utils/messageNotifi.dart';


Future<void> addReview(
    String buyer,
    String type,
    String centerId,
    String petId,
    int rating,
    String comment,
    List<dynamic> imagePaths,
    String videoPath) async {


  try {
    Map<String, dynamic> encodeSeller(String type, String centerId) {
      return {
        'type': type,
        'centerId': centerId,
      };
    }

// Code to send the request
    var body = jsonEncode({
      "buyer": buyer,
      "seller": encodeSeller(type, centerId),
      "petId": petId,
      "rating": rating,
      "comment": comment,
      "images": imagePaths,
      "video": videoPath,
    });

    final response = await api('review', 'POST', body);

    print('test response: $response');
 

    if (response['success']) {
      notification(response['message'], false);
      
    } else {
      notification(response['message'], true);
    }
  } catch (e) {
    print('error when add review: $e');
    //  notification(e.toString(), true);
  }
}
