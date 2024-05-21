import 'package:found_adoption_application/models/location.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:intl/intl.dart';

class Pet {
  final String id;
  final PetCenter? centerId;
  final String namePet;
  final String petType;
  final String breed;
  final String gender;
  final double? age;
  final DateTime? birthday;
  final List<dynamic> color;
  final String inoculation;
  final String instruction;
  final String attention;
  final String hobbies;
  final String original;
  final String price;
  final int reducePrice;
  final DateTime? dateStartReduce;
  final DateTime? dateEndReduce;
  final bool free;
  List<dynamic> images;
  final String weight;
  List<dynamic>? favorites;
  final String? statusPaid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pet({
    required this.reducePrice,
    this.dateStartReduce,
    this.dateEndReduce,
    required this.id,
    this.centerId,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.gender,
    this.age,
    this.birthday,
    this.favorites,
    required this.color,
    required this.inoculation,
    required this.instruction,
    required this.attention,
    required this.hobbies,
    required this.original,
    required this.price,
    required this.free,
    required this.images,
    required this.weight,
    this.statusPaid,
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
              location: Location(
                  latitude: json['centerId']['location']['latitude'],
                  longitude: json['centerId']['location']['longitude']),
              phoneNumber: json['centerId']['phoneNumber'] as String,
              aboutMe: json['centerId']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['centerId']['createdAt']))
                  .add(const Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['centerId']['createdAt']))
                  .add(const Duration(hours: 7)),
            )
          : null,
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      gender: json['gender'],
      age: double.parse(json['age'] as String),
      birthday: json['birthday'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['birthday']))
              .add(const Duration(hours: 7))
          : null,
      color: json['color'] as List<dynamic>,
      inoculation: json['inoculation'],
      instruction: json['instruction'],
      attention: json['attention'],
      hobbies: json['hobbies'],
      original: json['original'],
      price: json['price'],
      free: json['free'] as bool,
      images: json['images'] as List<dynamic>,
      weight: json['weight'],
      favorites:
          json['favorites'] != null ? json['favorites'] as List<dynamic> : [],
      statusPaid: json['statusPaid'],
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
      reducePrice: json['reducePrice'] as int,
      dateStartReduce: json['dateStartReduce'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateStartReduce']))
              .add(const Duration(hours: 7))
          : null,
      dateEndReduce: json['dateEndReduce'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateEndReduce']))
              .add(const Duration(hours: 7))
          : null,
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
      'birthday': birthday,
      'color': color,
      'inoculation': inoculation,
      'instruction': instruction,
      'attention': attention,
      'hobbies': hobbies,
      'original': original,
      'images': images,
      'weight': weight,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

class PetCustom {
  final String id;
  final String namePet;
  final List<String> images;

  PetCustom({
    required this.id,
    required this.namePet,
    required this.images,
  });

  factory PetCustom.fromJson(Map<String, dynamic> json) {
    return PetCustom(
      id: json['_id'],
      namePet: json['namePet'],
      images: json['images'].cast<String>(),
    );
  }
}
