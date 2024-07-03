import 'package:intl/intl.dart';

class Voucher {
  final String id;
  final String code;
  final String type;
  final int discount;
  final int maxDiscount;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String createdBy;
  final int quantity;
  final int? used;
  final DateTime createdAt;
  final DateTime updatedAt;

  Voucher({
    required this.id,
    required this.code,
    required this.type,
    required this.discount,
    required this.maxDiscount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdBy,
    required this.quantity,
    this.used,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
        id: json['_id'] as String,
        code: json['code'] as String,
        type: json['type'] as String,
        discount: json['discount'] as int,
        maxDiscount: json['maxDiscount'] as int,
        startDate: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(json['startDate'])),
        endDate: (DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(json['endDate'])),
        status: json['status'] as String,
        createdBy: json['createdBy'] as String,
        quantity: json['quantity'] as int,
        used: json['used'] as int,
        createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(json['createdAt']))
            .add(const Duration(hours: 7)),
        updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(json['updatedAt']))
            .add(const Duration(hours: 7)));
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'code': code,
      'type': type,
      'discount': discount,
      'maxDiscount': maxDiscount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'createBy': createdBy,
      'quantity': quantity,
      'createAt': createdAt.toIso8601String(),
      'updateAt': updatedAt.toIso8601String(),
    };
  }
}
