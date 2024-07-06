import 'dart:convert';

import 'package:found_adoption_application/models/review.dart';
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
    String videoPath,
    String orderId) async {
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
      "orderId": orderId
    });

    final response = await api('review', 'POST', body);

    if (response['success']) {
      notification(response['message'], false);
    } else {
      notification(response['message'], true);
    }
  } catch (e) {
    //  notification(e.toString(), true);
  }
}

Future<List<Review>> getAllReviewOfCenter(centerId) async {
  var responseData;
  List<Review> reviews = [];
  try {
    responseData = await api('review/all/$centerId', 'GET', '');
    List<dynamic> reviewList = List.empty();

    reviewList = responseData['data'] ?? List.empty();
    reviews = reviewList.map((json) => Review.fromJson(json)).toList();
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  return reviews;
}
