

class Location {
  final String latitude;
  final String longitude;

  const Location({
    required this.latitude,
    required this.longitude,

  });

  // Factory method để tạo đối tượng Location từ JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

 
}
