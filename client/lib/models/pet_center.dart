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
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'avatar': avatar,
      'address': address,
      'location': location,
      'phoneNumber': phoneNumber,
      'email': email,
      'status': status,
      'aboutMe': aboutMe,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
