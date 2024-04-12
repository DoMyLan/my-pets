import 'package:intl/intl.dart';

class ShortVideo {
  final String id;
  final String? userId;
  final String? centerId;
  final String? petId;
  final String? imagePet;
  final String? namePet;
  final String name;
  final String avatar;
  final String content;
  final String video;
  final int? qtyLike;
  final int? qtyComment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShortVideo({
    required this.id,
    this.userId,
    this.centerId,
    this.petId,
    this.imagePet,
    this.namePet,
    required this.name,
    required this.avatar,
    required this.content,
    required this.video,
    this.qtyLike,
    this.qtyComment,
    this.createdAt,
    this.updatedAt,
  });

  factory ShortVideo.fromJson(Map<String, dynamic> json) {
    return ShortVideo(
      id: json['_id'],
      userId: json['centerId'] != null ? null : json['userId']['_id'] as String,
      centerId:
          json['centerId'] != null ? json['centerId']['_id'] as String : null,
      petId: json['petId'] != null ? json['petId']['_id'] as String : null,
      imagePet: json['petId'] != null
          ? (json['petId']['iamges'] as List<dynamic>)[0]
          : null,
      namePet:
          json['petId'] != null ? json['petId']['namePet'] as String : null,
      name: json['centerId'] != null
          ? json['centerId']['name'] as String
          : json['userId']['firstName'] + ' ' + json['userId']['lastName']
              as String,
      avatar: json['centerId'] != null
          ? json['centerId']['avatar']
          : json['userId']['avatar'],
      content: json['content'],
      video: json['video'],
      qtyLike: (json['reaction'] as List<dynamic>).length,
      qtyComment: (json['comments'] as List<dynamic>).length,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(const Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(const Duration(hours: 7)),
    );
  }
}
