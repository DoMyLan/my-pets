import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/models/location.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:intl/intl.dart';

class Post {
  final String id;
  User? userId;
  PetCenter? petCenterId;
  final String content;
  List<dynamic>? images;
  List<Comment>? comments;
  List<dynamic>? reaction;
  String? status;
  DateTime createdAt;
  Pet? petId;

  Post(
      {required this.id,
      this.userId,
      this.petCenterId,
      required this.content,
      this.images,
      this.comments,
      this.reaction,
      this.petId,
      required this.createdAt,
      required this.status});

  factory Post.fromJson(Map<String, dynamic> json) {
    var commentList = json['comments'] as List<dynamic>;
    return Post(
      id: json['_id'] as String,
      userId: json['userId'] != null
          ? User(
              id: json['userId']['_id'] as String,
              firstName: json['userId']['firstName'] as String,
              lastName: json['userId']['lastName'] as String,
              avatar: json['userId']['avatar'] as String,
              address: json['userId']['address'] as String,
              location: Location(
                  latitude: json['userId']['location']['latitude'],
                  longitude: json['userId']['location']['longitude']),
              phoneNumber: json['userId']['phoneNumber'] as String,
              aboutMe: json['userId']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['userId']['createdAt']))
                  .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['userId']['updatedAt']))
                  .add(Duration(hours: 7)),
            )
          : null,
      petCenterId: json['centerId'] != null
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
                  .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['centerId']['createdAt']))
                  .add(Duration(hours: 7)),
            )
          : null,
      content: json['content'] as String,
      images: json['images'] as List<dynamic>,
      reaction: json['reaction'] as List<dynamic>,
      comments: commentList.map((json) => Comment.fromJson(json)).toList(),
      petId: json['petId'] != null
          ? Pet(
              id: json['petId']['_id'] as String,
              namePet: json['petId']['namePet'] as String,
              petType: json['petId']['petType'] as String,
              breed: json['petId']['breed'] as String,
              gender: json['petId']['gender'] as String,
              color: json['petId']['color'] as List<dynamic>,
              inoculation: json['petId']['inoculation'] as String,
              instruction: json['petId']['instruction'] as String,
              attention: json['petId']['attention'] as String,
              hobbies: json['petId']['hobbies'] as String,
              original: json['petId']['original'] as String,
              price: json['petId']['price'] as String,
              free: json['petId']['free'] as bool,
              images: json['petId']['images'] as List<dynamic>,
              weight: json['petId']['weight'] as String,
              statusAdopt: json['petId']['statusAdopt'] as String,
            )
          : null,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      status: json['status'],
    );
  }
}
