import 'package:intl/intl.dart';

class PetInventory {
  String id;
  String name;
  List<String> image;
  String type;
  DateTime createdAt;
  int daysInStock = 50;

  PetInventory({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.createdAt,
  });

  factory PetInventory.fromJson(Map<String, dynamic> json) {
    return PetInventory(
      id: json['_id'] as String,
      name: json['namePet'] as String,
      image: List<String>.from(json['images'] as List<dynamic>),
      type: json['petType'] as String,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
    );
  }
}
