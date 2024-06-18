class Follower {
  final String id;
  final String name;
  final String avatar;
  late bool isFollowed;

  Follower(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.isFollowed});

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['_id'],
      name: json['firstName'] == null
          ? json['name']
          : json['firstName'] + ' ' + json['lastName'],
      avatar: json['avatar'],
      isFollowed: false,
    );
  }
}
