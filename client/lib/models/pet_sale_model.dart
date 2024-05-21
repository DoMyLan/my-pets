class PetSale {
  final String id;
  final String name;
  final String breed;
  final String image;
  final double price;
  final int reducePrice;

  PetSale({
    required this.id,
    required this.name,
    required this.breed,
    required this.image,
    required this.price,
    required this.reducePrice,
  });

  factory PetSale.fromJson(Map<String, dynamic> json) {
    return PetSale(
      id: json['_id'] as String,
      name: json['namePet'] as String,
      breed: json['breed'] as String,
      image: (json['images'] as List<dynamic>)[0],
      price: double.parse(json['price']),
      reducePrice: json['reducePrice'] as int,
    );
  }
}
