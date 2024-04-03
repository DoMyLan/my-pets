import 'dart:convert';
import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<List<Comment>> getComment(String postId) async {
  var responseData = {};
  try {
    responseData = await api('post/$postId/comment', 'GET', '');
  } catch (e) {
    // notification(e.toString(), true);
  }
  var commentList = responseData['data'] as List<dynamic>;
  List<Comment> comments =
      commentList.map((json) => Comment.fromJson(json)).toList();
  return comments;
}

Future<String> deleteComment(String postId, String commentId) async {
  var responseData;
  var message = '';
  try {
    responseData = await api('post/$postId/comment/$commentId', 'DELETE', '');
    message = responseData['message'];
  } catch (err) {
    print(err);
    //  notification(e.toString(), true);
  }
  return message;
}

Future<String> postComment(String postID, String content) async {
  var responseData = {};
  var body = jsonEncode({"content": content});
  try {
    responseData = await api('post/$postID/comment', 'POST', body);
    return responseData['_id'];
  } catch (e) {
    print(e);
    if (responseData['message'] == 'Post not found!') {
      notification('You cannot comment on hidden posts', true);
      return '';
    } else
      notification(e.toString(), true);
      return '';
  }
  
}
