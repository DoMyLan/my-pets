class Follow {
  final String id;
  late List<String> followerUser;
  late List<String> followerCenter;
  late List<String> followingUser;
  late List<String> followingCenter;

  Follow({
    required this.id,
    required this.followerUser,
    required this.followerCenter,
    required this.followingUser,
    required this.followingCenter,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
        id: json['_id'],
        followerUser: List<String>.from(json['followerUser'] as List<dynamic>),
        followerCenter:
            List<String>.from(json['followerCenter'] as List<dynamic>),
        followingUser:
            List<String>.from(json['followingUser'] as List<dynamic>),
        followingCenter:
            List<String>.from(json['followingCenter'] as List<dynamic>));
  }
}
