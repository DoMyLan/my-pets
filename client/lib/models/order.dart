import 'package:intl/intl.dart';

class PetOrder {
  final String id;
  final String? giver;
  final String? centerId;
  final String namePet;
  final String petType;
  final String breed;
  final String price;
  final bool free;
  List<dynamic> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PetOrder({
    required this.id,
    this.centerId,
    this.giver,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.price,
    required this.free,
    required this.images,
    this.createdAt,
    this.updatedAt,
  });

  factory PetOrder.fromJson(Map<String, dynamic> json) {
    return PetOrder(
      id: json['_id'],
      centerId: json['centerId'],
      giver: json['giver'],
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      price: json['price'],
      free: json['free'] as bool,
      images: json['images'] as List<dynamic>,
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
  final int voucherProduct;
  final int voucherShipping;
  final int voucherTotal;
  final int transportFee;
  final int totalFee;
  final int totalPayment;
  final String paymentMethods;
  late String statusOrder;
  late String? statusPayment;
  final DateTime? dateConfirm;
  final DateTime? dateDelivering;
  final DateTime? dateCompleted;
  final DateTime? dateCancel;
  final DateTime? datePaid;
  final bool rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.petId,
    required this.address,
    required this.price,
    required this.voucherProduct,
    required this.voucherShipping,
    required this.voucherTotal,
    required this.transportFee,
    required this.totalFee,
    required this.totalPayment,
    required this.paymentMethods,
    required this.statusOrder,
    this.statusPayment,
    this.dateConfirm,
    this.dateDelivering,
    this.dateCompleted,
    this.dateCancel,
    this.datePaid,
    required this.rating,
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
      voucherProduct: json['voucherProduct'],
      voucherShipping: json['voucherShipping'],
      voucherTotal: json['voucherTotal'],
      transportFee: int.parse(json['transportFee']),
      totalFee: int.parse(json['totalFee']),
      totalPayment: json['totalPayment'],
      paymentMethods: json['paymentMethods'],
      statusOrder: json['statusOrder'],
      statusPayment: json['statusPayment'],
      dateConfirm: json['dateConfirm'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateConfirm']))
              .add(const Duration(hours: 7))
          : null,
      dateDelivering: json['dateDelivering'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateDelivering']))
              .add(const Duration(hours: 7))
          : null,
      dateCompleted: json['dateCompleted'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateCompleted']))
              .add(const Duration(hours: 7))
          : null,
      dateCancel: json['dateCancel'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateCancel']))
              .add(const Duration(hours: 7))
          : null,
      datePaid: json['datePaid'] != null
          ? (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['datePaid']))
              .add(const Duration(hours: 7))
          : null,
      rating: json['rating'] as bool,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }

  get shippingFee => null;

  get totalPrice => null;
}
