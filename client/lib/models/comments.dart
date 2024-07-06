import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:intl/intl.dart';

import 'location.dart';

class Comment {
  final String id;
  User? userId;
  PetCenter? centerId;
  final String? commentId;
  final String content;
  final DateTime? createdAt;

  Comment(
      {required this.id,
      this.userId,
      this.centerId,
      this.commentId,
      required this.content,
      this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['_id'],
        userId: json['userId'] != null
            ? User(
                id: json['userId']['_id'] as String,
                firstName: json['userId']['firstName'] as String,
                lastName: json['userId']['lastName'] as String,
                avatar: json['userId']['avatar'] as String,
                address: json['userId']['address'] as String,
                phoneNumber: json['userId']['phoneNumber'] as String,
                aboutMe: json['userId']['aboutMe'] as String,
                createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(json['userId']['createdAt']))
                    .add(Duration(hours: 7)),
                updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(json['userId']['updatedAt']))
                    .add(Duration(hours: 7)),
                location: json['userId']['location'] != null
                    ? Location(
                        latitude: json['userId']['location']['latitude'],
                        longitude: json['userId']['location']['longitude'])
                    : const Location(latitude: "0", longitude: "0"),
              )
            : null,
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
                location: json['centerId']['location'] != null
                    ? Location(
                        latitude: json['centerId']['location']['latitude'],
                        longitude: json['centerId']['location']['longitude'])
                    : const Location(latitude: "0", longitude: "0"),
              )
            : null,
        commentId: json['commentId'] ?? null,
        content: json['content'] ?? '',
        createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
            .add(Duration(hours: 7)));
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'centerId':
          centerId?.toMap(), // Đảm bảo cũng có hàm toMap trong class PetCenter
      'commentId': commentId,
      'content': content,
      'createdAt': createdAt!.toIso8601String()
    };
  }
}
