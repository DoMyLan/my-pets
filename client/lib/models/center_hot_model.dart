class CenterHot {
  late String id;
  late String name;
  late String avatar;
  late double rating;
  late int sold;
  late bool follow;

  CenterHot({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.sold,
    required this.follow,
  });

  CenterHot.fromJson(Map<String, dynamic> json) {
    id = json['centerId'] as String;
    name = json['name'] as String;
    avatar = json['avatar'] as String;
    rating = double.parse(json['rating'].toString());
    sold = json['sold'] as int;
    follow = false;
  }
}
