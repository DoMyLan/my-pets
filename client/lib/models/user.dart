import 'package:found_adoption_application/models/location.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? address;
  final Location location;
  final String? phoneNumber;
  final String? email;
  final String? status;
  final String? aboutMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
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
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'status': status,
      'aboutMe': aboutMe
    };
  }
}
