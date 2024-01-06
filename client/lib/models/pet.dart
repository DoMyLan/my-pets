import 'package:found_adoption_application/models/user.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:intl/intl.dart';

class Pet {
  final String id;
  final PetCenter? centerId;
  final String? centerId_id;
  final String namePet;
  final String petType;
  final String breed;
  final String gender;
  final double age;
  final String color;
  final String description;
  List<dynamic> images;
  final String level;
  final User? foundOwner;
  final String? foundOwner_id;
  final String statusAdopt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pet({
    required this.id,
    this.centerId,
    this.centerId_id,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.gender,
    required this.age,
    required this.color,
    required this.description,
    required this.images,
    required this.level,
    this.foundOwner,
    this.foundOwner_id,
    required this.statusAdopt,
    this.createdAt,
    this.updatedAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'],
      centerId: json['centerId'] != null
          ? PetCenter(
              id: json['centerId']['_id'] as String,
              name: json['centerId']['name'] as String,
              avatar: json['centerId']['avatar'] as String,
              address: json['centerId']['address'] as String,
              phoneNumber: json['centerId']['phoneNumber'] as String,
              aboutMe: json['centerId']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['centerId']['createdAt']))
                  .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['centerId']['createdAt']))
                  .add(Duration(hours: 7)),
            )
          : null,
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      gender: json['gender'],
      age: double.parse(json['age'] as String),
      color: json['color'],
      description: json['description'],
      images: json['images'] as List<dynamic>,
      level: json['level'],
      foundOwner: json['foundOwner'] != null
          ? User(
              id: json['foundOwner']['_id'] as String,
              firstName: json['foundOwner']['firstName'] as String,
              lastName: json['foundOwner']['lastName'] as String,
              avatar: json['foundOwner']['avatar'] as String,
              address: json['foundOwner']['address'] as String,
              phoneNumber: json['foundOwner']['phoneNumber'] as String,
              aboutMe: json['foundOwner']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['foundOwner']['createdAt']))
                  .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['foundOwner']['updatedAt']))
                  .add(Duration(hours: 7)),
            )
          : null,
      statusAdopt: json['statusAdopt'],
      centerId_id: json['centerId']['_id'],
      foundOwner_id: json['statusAdopt'] == 'HAS_ONE_OWNER'
          ? json['foundOwner']['_id']
          : null,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(Duration(hours: 7)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'centerId':
          centerId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'namePet': namePet,
      'petType': petType,
      'breed': breed,
      'gender': gender,
      'age': age,
      'color': color,
      'description': description,
      'images': images,
      'level': level,
      'foundOwner': foundOwner,
      'statusAdopt': statusAdopt,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
