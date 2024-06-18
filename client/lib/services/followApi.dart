import 'dart:convert';
import 'package:found_adoption_application/models/follow_model.dart';
import 'package:found_adoption_application/models/follower.dart';
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

Future<Follow> getFollowCenter() async {
  var responseData = {};
  try {
    responseData = await api('follow/center', 'GET', '');
    var followList = responseData['data'];
    Follow follows = Follow.fromJson(followList);
    return follows;
  } catch (e) {
    // notification(e.toString(), true);
    return Follow(
        id: '',
        followerUser: [],
        followerCenter: [],
        followingUser: [],
        followingCenter: []);
  }
}

class ResultFollower {
  late List<Follower> followerUser;
  late List<Follower> followerCenter;

  ResultFollower({required this.followerUser, required this.followerCenter});
}

Future<ResultFollower> getFollower(String id) async {
  var responseData = {};
  try {
    responseData = await api('follow/follower/$id', 'GET', '');
    var followList = responseData['data']['followerUser'] as List<dynamic>;
    List<Follower> follows =
        followList.map((json) => Follower.fromJson(json)).toList();
    var followList2 = responseData['data']['followerCenter'] as List<dynamic>;
    List<Follower> follows2 =
        followList2.map((json) => Follower.fromJson(json)).toList();
    return ResultFollower(followerUser: follows, followerCenter: follows2);
  } catch (e) {
    // notification(e.toString(), true);
    return ResultFollower(followerUser: [], followerCenter: []);
  }
}


class ResultFollowing {
  late List<Follower> followingUser;
  late List<Follower> followingCenter;

  ResultFollowing({required this.followingUser, required this.followingCenter});
}

Future<ResultFollowing> getFollowing(String id) async {
  var responseData = {};
  try {
    responseData = await api('follow/following/$id', 'GET', '');
    var followList = responseData['data']['followingUser'] as List<dynamic>;
    List<Follower> follows =
        followList.map((json) => Follower.fromJson(json)).toList();
    var followList2 = responseData['data']['followingCenter'] as List<dynamic>;
    List<Follower> follows2 =
        followList2.map((json) => Follower.fromJson(json)).toList();
    return ResultFollowing(followingUser: follows, followingCenter: follows2);
  } catch (e) {
    // notification(e.toString(), true);
    return ResultFollowing(followingUser: [], followingCenter: []);
  }
}