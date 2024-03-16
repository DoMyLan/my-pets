import 'package:intl/intl.dart';

class PetOrder {
  final String id;
  final String? giver;
  final String? rescue;
  final String? linkCenter;
  final String? centerId;
  final String namePet;
  final String petType;
  final String breed;
  final String gender;
  final double? age;
  final DateTime? birthday;
  final String color;
  final String price;
  final bool free;

  final String description;
  List<dynamic> images;
  final String level;
  List<dynamic>? favorites;
  final String? foundOwner;
  final String statusAdopt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PetOrder({
    required this.id,
    this.centerId,
    this.giver,
    this.rescue,
    this.linkCenter,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.gender,
    this.age,
    this.birthday,
    this.favorites,
    required this.color,
    required this.price,
    required this.free,
    required this.description,
    required this.images,
    required this.level,
    this.foundOwner,
    required this.statusAdopt,
    this.createdAt,
    this.updatedAt,
  });

  factory PetOrder.fromJson(Map<String, dynamic> json) {
    return PetOrder(
      id: json['_id'],
      centerId: json['centerId'],
      giver: json['giver'],
      rescue: json['rescue'],
      linkCenter: json['linkCenter'],
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      gender: json['gender'],
      age: double.parse(json['age'] as String),
      birthday: json['birthday'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['birthday']))
              .add(const Duration(hours: 7))
          : null,
      color: json['color'],
      price: json['price'],
      free: json['free'] as bool,
      description: json['description'],
      images: json['images'] as List<dynamic>,
      level: json['level'],
      favorites:
          json['favorites'] != null ? json['favorites'] as List<dynamic> : [],
      foundOwner: json['foundOwner'],
      statusAdopt: json['statusAdopt'],
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }
}

class CenterOrder {
  final String id;
  final String name;
  final String avatar;
  final String address;
  final String phoneNumber;

  const CenterOrder({
    required this.id,
    required this.name,
    required this.avatar,
    required this.address,
    required this.phoneNumber,
  });

  factory CenterOrder.fromJson(Map<String, dynamic> json) {
    return CenterOrder(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class UserOrder {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String address;
  final String phoneNumber;

  const UserOrder({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.address,
    required this.phoneNumber,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class Seller {
  final String typeSeller;
  final UserOrder? userId;
  final CenterOrder? centerId;

  const Seller(
      {required this.typeSeller, required this.userId, required this.centerId});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      typeSeller: json['typeSeller'],
      userId:
          json['userId'] != null ? UserOrder.fromJson(json['userId']) : null,
      centerId: json['centerId'] != null
          ? CenterOrder.fromJson(json['centerId'])
          : null,
    );
  }
}

class Buyer {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String avatar;

  const Buyer(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.address,
      required this.avatar});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      avatar: json['avatar'],
    );
  }
}

class Order {
  final String id;
  final Seller seller;
  final Buyer buyer;
  final PetOrder petId;
  final String address;
  final int price;
  final int transportFee;
  final int totalFee;
  final String paymentMethods;
  final String statusOrder;
  final String statusPayment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.petId,
    required this.address,
    required this.price,
    required this.transportFee,
    required this.totalFee,
    required this.paymentMethods,
    required this.statusOrder,
    required this.statusPayment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      seller: Seller.fromJson(json['seller']),
      buyer: Buyer.fromJson(json['buyer']),
      petId: PetOrder.fromJson(json['petId']),
      address: json['address'],
      price: int.parse(json['price']),
      transportFee: int.parse(json['transportFee']),
      totalFee: int.parse(json['totalFee']),
      paymentMethods: json['paymentMethods'],
      statusOrder: json['statusOrder'],
      statusPayment: json['statusPayment'],
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }

  get shippingFee => null;

  get totalPrice => null;
}
