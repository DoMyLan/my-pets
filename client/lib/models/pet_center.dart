import 'package:found_adoption_application/models/location.dart';

class PetCenter {
  final String id;
  final String name;
  final String avatar;
  final String address;
  final Location location;
  final String phoneNumber;
  final String? email;
  final String? status;
  final String? aboutMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PetCenter({
    required this.id,
    required this.name,
    required this.avatar,
    required this.address,
    required this.location,
    required this.phoneNumber,
    this.email,
    this.status,
    this.aboutMe,
    this.createdAt,
    this.updatedAt,
  });

  factory PetCenter.fromJson(Map<String, dynamic> json) {
    return PetCenter(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'],
      address: json['address'],
      location: Location.fromJson(json['location']),
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      status: json['status'],
      aboutMe: json['aboutMe'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'avatar': avatar,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'status': status,
      'aboutMe': aboutMe
    };
  }
}
