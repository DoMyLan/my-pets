import 'package:found_adoption_application/models/location.dart';

class CenterHot {
  late String id;
  late String name;
  late String avatar;
  late double rating;
  late int sold;
  late List<String> followerUser;
  late List<String> followerCenter;
  late bool follow;
  late int follower = 0;
  late String aboutMe;
  late Location location;

  CenterHot({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.sold,
    required this.followerUser,
    required this.followerCenter,
    required this.follow,
    required this.follower,
    required this.aboutMe,
    required this.location,
  });

  CenterHot.fromJson(Map<String, dynamic> json) {
    id = json['centerId'] as String;
    name = json['name'] as String;
    avatar = json['avatar'] as String;
    rating = double.parse(json['rating'].toString());
    sold = json['sold'] as int;
    followerUser = List<String>.from(json['followerUser'] as List<dynamic>);
    followerCenter = List<String>.from(json['followerCenter'] as List<dynamic>);
    follow = false;
    aboutMe = json['aboutMe'] as String;
    location = Location.fromJson(json['location'] as Map<String, dynamic>);
  }
}
