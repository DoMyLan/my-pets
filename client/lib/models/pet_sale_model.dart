class PetSale {
  final String id;
  final String name;
  final String breed;
  final String image;
  final double price;
  final double reducedPrice;

  PetSale({
    required this.id,
    required this.name,
    required this.breed,
    required this.image,
    required this.price,
    required this.reducedPrice,
  });

  factory PetSale.fromJson(Map<String, dynamic> json) {
    return PetSale(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      image: (json['image'] as List<String>)[0],
      price: double.parse(json['price']),
      reducedPrice: json['reducedPrice'] as double,
    );
  }
}
