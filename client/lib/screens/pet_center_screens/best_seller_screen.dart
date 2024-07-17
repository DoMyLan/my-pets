import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/pet_breed.dart';
import 'package:found_adoption_application/services/center/petApi.dart';

class BreedBestSeller {
  final String name;
  late int sold;
  late int view;
  late int inventory;
  late String avatar;

  BreedBestSeller({
    required this.name,
    required this.sold,
    required this.view,
    required this.inventory,
    this.avatar =
        "https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2019/10/nuoi-meo-can-gi-0-1024x713.jpg",
  });

  factory BreedBestSeller.fromJson(Map<String, dynamic> json) {
    return BreedBestSeller(
      name: json['breed'] as String,
      sold: json['sold'] as int,
      view: json['view'] as int,
      inventory: json['inventory'] as int,
    );
  }
  static List<BreedBestSeller> generate(breedName) {
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
    List<BreedBestSeller> breeds = [];
    for (var i = 0; i < breed.length; i++) {
      breeds.add(BreedBestSeller(
          name: breed[i],
          avatar: breedImage[i],
          sold: 0,
          view: 0,
          inventory: 0));
    }
    return breeds;
  }
}

class BestSellingPetsScreen extends StatefulWidget {
  const BestSellingPetsScreen({super.key});

  @override
  State<BestSellingPetsScreen> createState() => _BestSellingPetsScreenState();
}

class _BestSellingPetsScreenState extends State<BestSellingPetsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thú Cưng Bán Chạy'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chó'),
              Tab(text: 'Mèo'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab Chó
            BreedWidget(type: "Dog"),
            // Tab Mèo
            BreedWidget(type: "Cat"),
          ],
        ),
      ),
    );
  }
}

class BreedWidget extends StatefulWidget {
  final String type;
  const BreedWidget({
    super.key,
    required this.type,
  });

  @override
  State<BreedWidget> createState() => _BreedWidgetState();
}

class _BreedWidgetState extends State<BreedWidget> {
  Future<List<BreedBestSeller>>? petStatsList;
  late List<BreedBestSeller> breedList = [];

  @override
  void initState() {
    super.initState();
    petStatsList = getPetStats(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: petStatsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Đã xảy ra lỗi'),
            );
          }

          List<BreedBestSeller> getBreed =
              snapshot.data as List<BreedBestSeller>;

          breedList = BreedBestSeller.generate(widget.type);
          for (var i = 0; i < breedList.length; i++) {
            breedList[i].view = getBreed[i].view;
            breedList[i].sold = getBreed[i].sold;
            breedList[i].inventory = getBreed[i].inventory;
          }

          breedList.sort((a, b) {
            if (a.sold == b.sold) {
              return b.view.compareTo(a.view);
            }
            return b.sold.compareTo(a.sold);
          });

          return ListView.builder(
            itemCount:
                breedList.length, // Giả sử petStatsList chứa cả chó và mèo
            itemBuilder: (context, index) {
              return buildPetTile(breedList[index]);
            },
          );
        });
  }

  Widget buildPetTile(pet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PetBreed(
            breed: pet.name,
          );
        }));
      },
      child: Card(
        elevation: 4.0, // Độ cao của thẻ, tạo hiệu ứng đổ bóng
        margin: const EdgeInsets.all(8.0), // Khoảng cách xung quanh thẻ
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Khoảng cách bên trong thẻ
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Căn chỉnh nội dung bên trái
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0, // Kích thước của ảnh
                    backgroundImage: AssetImage(pet.avatar),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa ảnh và tiêu đề
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 18.0, // Kích thước chữ của tiêu đề
                            fontWeight: FontWeight.bold, // Độ đậm của chữ
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Dấu "..." nếu tiêu đề quá dài
                        ),
                        Text(
                          'Còn lại: ${pet.inventory}', // Hiển thị số lượng còn lại
                          style: const TextStyle(
                            fontSize: 14.0, // Kích thước chữ nhỏ hơn
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 10), // Khoảng cách giữa tiêu đề và thông tin
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Căn chỉnh các icon đều nhau
                children: <Widget>[
                  Row(
                    children: [
                      const Icon(Icons.sell, size: 16),
                      const Text(' Đã bán:'),
                      Text(' ${pet.sold}'),
                    ],
                  ), // Giá
                  Row(
                    children: [
                      const Icon(Icons.visibility, size: 16),
                      const Text(' Lượt xem:'),
                      Text(' ${pet.view}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
