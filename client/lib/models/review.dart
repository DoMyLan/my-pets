import 'package:intl/intl.dart';

class CenterId {
  final String id;
  final String name;
  final String avatar;

  const CenterId({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory CenterId.fromJson(Map<String, dynamic> json) {
    return CenterId(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class UserId {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;

  const UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }
}

class Seller {
  final String type;
  final UserId? userId;
  final CenterId? centerId;

  const Seller(
      {required this.type, required this.userId, required this.centerId});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      type: json['type'],
      userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
      centerId:
          json['centerId'] != null ? CenterId.fromJson(json['centerId']) : null,
    );
  }
}

class Buyer {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;

  const Buyer(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.avatar});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }
}

class PetId {
  final String id;
  final String namePet;
  final String petType;
  final String breed;
  final String price;
  final String weight;
  final DateTime? birthday;
  final List<dynamic> images;
  final List<dynamic> color;

  PetId({
    required this.id,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.price,
    required this.images,
    required this.color,
    required this.weight,
    this.birthday,
  });

  factory PetId.fromJson(Map<String, dynamic> json) {
    return PetId(
      id: json['_id'],
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      price: json['price'],
      images: json['images'] as List<dynamic>,
      color: json['color'] as List<dynamic>,
      weight: json['weight'] as String,
      birthday: json['birthday'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['birthday']))
              .add(const Duration(hours: 7))
          : null,
    );
  }
}

class Review {
  final String id;
  final Seller seller;
  final Buyer buyer;
  final PetId petId;
  final int rating;
  final String comment;
  final List<dynamic>? images;
  final String? video;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.petId,
    required this.rating,
    required this.comment,
    required this.images,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      seller: Seller.fromJson(json['seller']),
      buyer: Buyer.fromJson(json['buyer']),
      petId: PetId.fromJson(json['petId']),
      rating: json['rating'],
      comment: json['comment'],
      images: json['images'] as List<dynamic>,
      video: json['video'],
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }
}
