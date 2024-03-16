import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/like_model.dart';
import 'package:found_adoption_application/services/api.dart';

Future<void> like(BuildContext context, postId) async {
  try {
    await api('post/${postId}/reaction', 'PUT', '');
  } catch (e) {
    print(e);
  //  notification(e.toString(), true);
  }
}

Future<List<Like>> getLike(BuildContext context, postId) async {
  var responseData;
  try {
    responseData = await api('post/${postId}/reaction', 'GET', '');
  } catch (e) {
    print(e);
  //  notification(e.toString(), true);
  }
  var likeList = responseData['data'] as List<dynamic>;
  List<Like> like = likeList.map((json) => Like.fromJson(json)).toList();
  return like;
}
