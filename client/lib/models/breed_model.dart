class Breed {
  late String name;
  late String asset;
  late int sold;
  late int view;

  Breed(
      {required this.name,
      required this.asset,
      required this.sold,
      required this.view});

  static List<Breed> generate(breedName) {
    var breed;
    var breedImage;
    if (breedName == "Cat") {
      breed = [
        "Mèo Ba Tư",
        "Mèo Ai Cập",
        "Mèo Anh lông dài",
        "Mèo Xiêm",
        "Mèo Munchkin",
        "Mèo Ragdoll",
        "Mèo Mướp",
        "Mèo Vàng",
        "Mèo Mun",
        "Mèo khác"
      ];

      breedImage = [
        "assets/cats/batu.jpg",
        "assets/cats/aicap.jpg",
        "assets/cats/anhlongdai.jpg",
        "assets/cats/xiem.jpg",
        "assets/cats/munchkin.jpg",
        "assets/cats/ragdoll.jpg",
        "assets/cats/muop.jpg",
        "assets/cats/vang.png",
        "assets/cats/mun.jpg",
        "assets/cats/khac.jpg",
      ];
    } else if (breedName == "Dog") {
      breed = [
        "Chó Alaska",
        "Chó Bắc Kinh",
        "Chó Beagle",
        "Chó Becgie",
        "Chó Chihuahua",
        "Chó Corgi",
        "Chó Dachshund",
        "Chó Golden",
        "Chó Husky",
        "Chó Phốc Sóc",
        "Chó Poodle",
        "Chó Pug",
        "Chó Samoyed",
        "Chó Shiba",
        "Chó cỏ",
        "Chó khác"
      ];

      breedImage = [
        "assets/dogs/alaska.jpg",
        "assets/dogs/backinh.jpg",
        "assets/dogs/beagle.jpg",
        "assets/dogs/becgie.jpg",
        "assets/dogs/chihuahua.jpg",
        "assets/dogs/corgi.jpg",
        "assets/dogs/dachshund.jpg",
        "assets/dogs/golden.jpg",
        "assets/dogs/husky.jpg",
        "assets/dogs/phocsoc.jpg",
        "assets/dogs/poodle.jpg",
        "assets/dogs/pug.jpg",
        "assets/dogs/samoyed.jpg",
        "assets/dogs/shiba.jpg",
        "assets/dogs/choco.jpg",
        "assets/dogs/khac.jpg"
      ];
    }
    List<Breed> breeds = [];
    for (var i = 0; i < breed.length; i++) {
      breeds.add(Breed(name: breed[i], asset: breedImage[i], sold: 0, view: 0));
    }
    return breeds;
  }

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
        name: json['breed'],
        asset: "null",
        sold: json['sold'] as int,
        view: json['view'] as int);
  }
}
