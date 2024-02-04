import 'dart:convert';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:image_picker/image_picker.dart';

class PostResult {
  final List<Post> posts;
  final int totalPages;
  final int totalPost;
  final int page;

  PostResult(
      {required this.posts,
      required this.totalPages,
      required this.totalPost,
      required this.page});
}

Future<PostResult> getAllPost(page, limit) async {
  var responseData = {};
  try {
    responseData = await api('/post/?limit=$limit&page=$page', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var postList = responseData['data'] as List<dynamic>;
  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();
  return PostResult(
      posts: posts,
      totalPages: responseData['totalPages'],
      totalPost: responseData['totalPost'],
      page: responseData['page']);
}

Future<Post> getOnePost(String postId) async {
  var responseData = {};
  try {
    responseData = await api('/post/$postId', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  Post post = Post.fromJson(responseData['data']);
  return post;
}

Future<String> changeStatusPost(String postId, String status) async {
  var body = jsonEncode(<String, String>{'status': status});
  var responseData = {};
  var message;
  try {
    responseData = await api('/post/$postId/status', 'PUT', body);
    message = responseData['message'];
  } catch (err) {
    print(err);
    //  notification(e.toString(), true);
  }
  return message;
}

Future<List<Post>> getAllPostPersonal(var id) async {
  var responseData;
  try {
    responseData = await api('/post/personal/${id}', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  List<dynamic> postList = List.empty();

  postList = responseData['data'] != null ? responseData['data'] : List.empty();
  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();
  return posts;
}

Future<bool> addPost(String content, List<dynamic> imagePaths) async {
  var responseData = {};
  var body = jsonEncode({
    "content": content,
    "images": imagePaths,
  });
  try {
    responseData = await api('/post', 'POST', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RegistrationForm()));
      return true;
    } else {
      notification(responseData['message'], true);
      return false;
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
    return false;
  }
}

Future<void> updatePost(String content, List<XFile> imagePaths,
    bool isNewUpload, String postId) async {
  var responseData = {};
  List<dynamic> finalResult = [];
  var result;

  if (imagePaths.isNotEmpty && isNewUpload) {
    result = await uploadMultiImage(imagePaths);
    finalResult = result.map((url) => url).toList();
  }

  var body = jsonEncode({
    "content": content,
    if (isNewUpload) "images": finalResult,
  });
  try {
    responseData = await api('/post/$postId', 'PUT', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}

Future<String> deleteOnePost(String postId) async {
  var responseData = {};
  try {
    responseData = await api('/post/$postId', 'DELETE', '');
  } catch (e) {
    print(e);
    notification(e.toString(), true);
  }
  return responseData['message'];
}

Future<void> reportPost(String postId, String title, String reason) async {
  var responseData = {};
  var body = jsonEncode({
    "title": title,
    "reason": reason,
  });
  try {
    responseData = await api('/report/$postId', 'POST', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}
