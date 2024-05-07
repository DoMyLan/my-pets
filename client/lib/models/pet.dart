import 'package:found_adoption_application/models/location.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:intl/intl.dart';

class Pet {
  final String id;
  final User? giver;
  final User? rescue;
  final PetCenter? linkCenter;
  final PetCenter? centerId;
  final String? centerId_id;
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
  final bool free;
  List<dynamic> images;
  final String weight;
  List<dynamic>? favorites;
  final User? foundOwner;
  final String? foundOwner_id;
  final String statusAdopt;
  final String? statusPaid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pet({
    required this.id,
    this.centerId,
    this.giver,
    this.rescue,
    this.linkCenter,
    this.centerId_id,
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
    this.foundOwner,
    this.foundOwner_id,
    required this.statusAdopt,
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
      centerId_id:
          json['centerId'] != null ? json['centerId']['_id'] as String : null,
      giver: json['giver'] != null
          ? User(
              id: json['giver']['_id'] as String,
              firstName: json['giver']['firstName'] as String,
              lastName: json['giver']['lastName'] as String,
              avatar: json['giver']['avatar'] as String,
              address: json['giver']['address'] as String,
              phoneNumber: json['giver']['phoneNumber'] as String,
              aboutMe: json['giver']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['giver']['createdAt']))
                  .add(const Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['giver']['updatedAt']))
                  .add(const Duration(hours: 7)),
              location: json['giver']['location'] != null
                  ? Location(
                      latitude: json['giver']['location']['latitude'],
                      longitude: json['giver']['location']['longitude'])
                  : Location(latitude: "0", longitude: "0"),
            )
          : null,
      rescue: json['rescue'] != null
          ? User(
              id: json['rescue']['_id'] as String,
              firstName: json['rescue']['firstName'] as String,
              lastName: json['rescue']['lastName'] as String,
              avatar: json['rescue']['avatar'] as String,
              address: json['rescue']['address'] as String,
              phoneNumber: json['rescue']['phoneNumber'] as String,
              aboutMe: json['rescue']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['rescue']['createdAt']))
                  .add(const Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['rescue']['updatedAt']))
                  .add(const Duration(hours: 7)),
              location: json['rescue']['location'] != null
                  ? Location(
                      latitude: json['rescue']['location']['latitude'],
                      longitude: json['rescue']['location']['longitude'])
                  : const Location(latitude: "0", longitude: "0"),
            )
          : null,
      linkCenter: json['linkCenter'] != null
          ? PetCenter(
              id: json['linkCenter']['_id'] as String,
              name: json['linkCenter']['name'] as String,
              avatar: json['linkCenter']['avatar'] as String,
              address: json['linkCenter']['address'] as String,
              phoneNumber: json['linkCenter']['phoneNumber'] as String,
              aboutMe: json['linkCenter']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['linkCenter']['createdAt']))
                  .add(const Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['linkCenter']['createdAt']))
                  .add(const Duration(hours: 7)),
              location: json['linkCenter']['location'] != null
                  ? Location(
                      latitude: json['linkCenter']['location']['latitude'],
                      longitude: json['linkCenter']['location']['longitude'])
                  : const Location(latitude: "0", longitude: "0"),
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
      foundOwner: json['foundOwner'] != null
          ? User(
              id: json['foundOwner']['_id'] as String,
              firstName: json['foundOwner']['firstName'] as String,
              lastName: json['foundOwner']['lastName'] as String,
              avatar: json['foundOwner']['avatar'] as String,
              address: json['foundOwner']['address'] as String,
              location: Location(
                  latitude: json['foundOwner']['location']['latitude'],
                  longitude: json['foundOwner']['location']['longitude']),
              phoneNumber: json['foundOwner']['phoneNumber'] as String,
              aboutMe: json['foundOwner']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['foundOwner']['createdAt']))
                  .add(const Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['foundOwner']['updatedAt']))
                  .add(const Duration(hours: 7)),
            )
          : null,
      statusAdopt: json['statusAdopt'],
      statusPaid: json['statusPaid'],
      // centerId_id: json['centerId']['_id'],
      // foundOwner_id: json['statusAdopt'] == 'HAS_ONE_OWNER'
      //     ? json['foundOwner']['_id']
      //     : null,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'centerId':
          centerId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'giver': giver?.toMap(),
      'rescue': rescue?.toMap(),
      'linkCenter': linkCenter?.toMap(),
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

      'foundOwner': foundOwner,
      'statusAdopt': statusAdopt,
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
