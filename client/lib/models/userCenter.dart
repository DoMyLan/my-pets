import 'package:intl/intl.dart';

class InfoCenter {
  final String id;
  final String accountId;
  final String email;
  final String role;
  final String status;
  final String name;
  final String avatar;
  final String phoneNumber;
  final String address;

  final String aboutMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  late bool follow;
  late List<String> followerUser;
  late List<String> followerCenter;
  late int follower = 0;
  late List<String> followingUser;
  late List<String> followingCenter;

  InfoCenter({
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.status,
    required this.name,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.aboutMe,
    this.createdAt,
    this.updatedAt,
    required this.follow,
    required this.followerUser,
    required this.followerCenter,
    required this.follower,
    required this.followingUser,
    required this.followingCenter,
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoCenter.fromJson(Map<String, dynamic> json) {
    return InfoCenter(
      id: json['_id'] as String,
      accountId: json['accountId']['_id'] as String,
      email: json['accountId']['email'] as String,
      role: json['accountId']['role'] as String,
      status: json['accountId']['status'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      aboutMe: json['aboutMe'] as String,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
      follow: false,
      followerUser: List<String>.from(json['followerUser'] as List<dynamic>),
      followerCenter:
          List<String>.from(json['followerCenter'] as List<dynamic>),
      followingUser: List<String>.from(json['followingUser'] as List<dynamic>),
      followingCenter:
          List<String>.from(json['followingCenter'] as List<dynamic>),
      follower: 0,
    );
  }
}
