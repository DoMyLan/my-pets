import 'package:found_adoption_application/models/location.dart';
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

  const InfoCenter({
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
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoCenter.fromJson(Map<String, dynamic> json) {
    return InfoCenter(
      id: json['_id'] as String,
      accountId: json['accountId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      aboutMe: json['aboutMe'] as String,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(Duration(hours: 7)),
    );
  }
}
