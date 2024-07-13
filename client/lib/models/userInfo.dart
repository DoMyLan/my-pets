import 'package:found_adoption_application/models/location.dart';
import 'package:intl/intl.dart';

class InfoUser {
  final Location location;
  final String id;
  final String accountId;
  final String email;
  final String role;
  final String status;
  final String firstName;
  final String lastName;
  final String avatar;
  final String phoneNumber;
  final String address;
  final bool experience;
  final String aboutMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  late bool follow;
  late List<String> followerUser;
  late List<String> followerCenter;
  late int follower = 0;
  late List<String> followingUser;
  late List<String> followingCenter;

  InfoUser({
    required this.location,
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.experience,
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
  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      location: Location.fromJson(json['location']),
      id: json['_id'] as String,
      accountId: json['accountId']['_id'] as String,
      email: json['accountId']['email'] as String,
      role: json['accountId']['role'] as String,
      status: json['accountId']['status'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      experience: json['experience'] ? json['experience'] : false,
      aboutMe: json['aboutMe'] as String,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(Duration(hours: 7)),
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
