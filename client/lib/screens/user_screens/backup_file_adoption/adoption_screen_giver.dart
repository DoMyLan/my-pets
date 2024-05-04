import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/age.dart';
import 'package:found_adoption_application/custom_widget/back_to_home.dart';
import 'package:found_adoption_application/custom_widget/quick_infor.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:found_adoption_application/screens/filter_dialog.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AdoptionScreenGiver extends StatefulWidget {
  const AdoptionScreenGiver({super.key});

  @override
  State<AdoptionScreenGiver> createState() => _AdoptionScreenGiverState();
}

class _AdoptionScreenGiverState extends State<AdoptionScreenGiver>
    with AutomaticKeepAliveClientMixin {
  late List<Pet> animals = [];
  List<Pet> filteredAnimals = [];
  late var currentClient;
  bool isLoading = true;
  late List<Pet> previousPets = []; // Dữ liệu của pets trước đó
  late bool dataFetched =
      false; // Biến trạng thái để kiểm tra liệu dữ liệu đã được fetch hay chưa
  int _currentIndex = 0;
   String selectedPetType = 'All';

   List<String> animalTypes = [
    'All',
    'Cat',
    'Dog',
  ];

  List<IconData?> animalIcons = [
    null,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
  ];

  //SEARCH AND FILTER
  final TextEditingController _searchController = TextEditingController();
   List<Pet> _searchResults = [];
   String _searchKeyword = '';


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  
    fetchPets();
    _searchController.clear();
    _searchController.addListener(_performSearch);
  }




  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Builder(builder: (BuildContext context) {
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 60),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TBackHomePage(),
                                    TuserQuickInfor(
                                        currentClient: currentClient),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(currentClient.avatar),
                                    ),
                                  ],
                                ),
                              ),
                              buildSearchAndAnimalTypes(),
                            ],
                          ),
                        ]),
                      ),
                    )
                  ];
                },
                body: IndexedStack(
                  index: _currentIndex,
                  children: [
                    // Trang 1
                    buildAnimalAdopt(),
                  ],
                ),
              );
            }),
      
    );
  }

  Future<List<Pet>>? futurePets;


  Widget buildSearchAndAnimalTypes() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.06),
      ),
      child: Column(
        children: [
          buildSearchBar(),
          buildAnimalTypes(),
        ],
      ),
    );
  }

  Widget buildAnimalTypes() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 24),
        scrollDirection: Axis.horizontal,
        itemCount: animalTypes.length,
        itemBuilder: (context, index) {
          return buildAnimalIcon(index);
        },
      ),
    );
  }

  Widget buildAnimalIcon(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            _searchController.clear();
            selectedPetType = animalTypes[index];
            _performSearch();
          });
        },
        child: Material(
          color: selectedPetType == animalTypes[index]
              ? Theme.of(context).primaryColor
              : Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (index != 0 && animalIcons[index] != null)
                  Icon(
                    animalIcons[index]!,
                    size: 20,
                    color: selectedPetType == animalTypes[index]
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                Text(
                  animalTypes[index],
                  style: TextStyle(
                    color: selectedPetType == animalTypes[index]
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    setState(() {
      if (selectedPetType != '') {
        if (selectedPetType == 'All') {
          _searchResults = List.from(animals);
          print('aaaa: $_searchResults');
        } else {
          _searchResults =
              animals.where((pet) => pet.petType == selectedPetType).toList();
        }
      } else {
        _searchResults = animals
            .where((pet) =>
                pet.breed.toLowerCase().contains(_searchKeyword.toLowerCase()))
            .toList();
      }
    });
  }

 

  Future<void> fetchPets() async {
    try {
      var temp = await getCurrentClient();
      setState(() {
        currentClient = temp;
        isLoading = false;
      });

      var pets = await getAllPetPersonal();
      if (!listEquals(pets, previousPets)) {
        // Nếu dữ liệu mới khác dữ liệu trước đó, cập nhật dữ liệu trước đó và hiển thị dữ liệu mới
        setState(() {
          previousPets = List.from(pets);
          animals = List.from(pets);
          dataFetched =
              true; // Đặt biến trạng thái thành true sau khi dữ liệu đã được fetch
        });
      }
    } catch (error) {
      // Xử lý lỗi
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8), // Giảm giá trị vertical để làm cho SearchBar nhỏ lại
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.search,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Search pet to adopt',
                        contentPadding: EdgeInsets.symmetric(
                            vertical:
                                8), // Giảm khoảng cách giữa các phần tử trong vùng nhập
                      ),
                      onChanged: (value) {
                        if (_searchKeyword != value) {
                          setState(() {
                            selectedPetType = '';
                            _searchKeyword = value;
                          });

                          _performSearch();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Rút ngắn chiều cao của Column
            crossAxisAlignment:
                CrossAxisAlignment.center, // Canh giữa theo chiều ngang
            children: [
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                color: Colors.blue,
                onPressed: showFilterDialog,
                iconSize: 30,
              ),
              Text(
                'Filter',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showFilterDialog() async {
    final Future<List<Pet>>? result = await showDialog<Future<List<Pet>>>(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            widthFactor: 0.9, // Chiều cao là 50% màn hình
            alignment: Alignment.center,
            heightFactor: 0.7,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: FilterDialog()),
          );
        });

    if (result != null) {
      setState(() {
        futurePets = result;
      });
    } else {
      setState(() {
        futurePets = result;
      });
    }
  }

  Widget buildAnimalAdopt() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.06),
      child: dataFetched
          ? FutureBuilder<List<Pet>>(
              future: futurePets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return errorWidget();
                } else {
                  return buildAnimalList(animals, filteredAnimals);
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget fieldInforPet(String infor, String inforDetail) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$infor: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: inforDetail,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimalList(List<Pet> animals, List<Pet> filteredAnimals) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: filteredAnimals.isNotEmpty
          ? filteredAnimals.length
          : _searchKeyword.isEmpty && selectedPetType == 'All'
              ? animals.length
              : _searchResults.length,
      itemBuilder: (context, index) {
        final animal = filteredAnimals.isNotEmpty
            ? filteredAnimals[index]
            : _searchKeyword.isEmpty && selectedPetType == 'All'
                ? animals[index]
                : _searchResults[index];

        calculateDistance(
                currentClient.location,
                animal.centerId != null
                    ? animal.centerId!.location
                    : animal.giver!.location)
            .then((value) {
          value.toStringAsFixed(2);
        });

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AnimalDetailScreen(
                    petId: animal.id,
                    currentId: currentClient,
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6, right: 4, left: 12),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: deviceWidth * 0.4),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  fieldInforPet('Name', animal.namePet),
                                  Icon(
                                    animal.gender == "FEMALE"
                                        ? FontAwesomeIcons.venus
                                        : FontAwesomeIcons.mars,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              fieldInforPet('Breed', animal.breed),
                              const SizedBox(height: 2),
                               fieldInforPet(
                                  'Age',
                                  animal.birthday != null
                                      ? AgePet.convertAge(animal.birthday!)
                                      : "unknown"),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    color: Colors.grey,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 1),
                                  Text(
                                    '       ${animal.price}.vnd',
                                    // '      2350000.vnd',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),


                              //DISTANCE
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.mapMarkerAlt,
                                    color: Theme.of(context).primaryColor,
                                    size: 14.0,
                                  ),
                                  const SizedBox(width: 1),
                                  Text(
                                    'Distance: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  FutureBuilder<double>(
                                    future: calculateDistance(
                                        currentClient.location,
                                        animal.centerId != null
                                            ? animal.centerId!.location
                                            : animal.giver!.location),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Calculating...');
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        String distanceString =
                                            snapshot.data!.toStringAsFixed(2);
                                        return Text(
                                          '$distanceString km',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          softWrap: true,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: animal.namePet,
                        child: Image(
                          image: NetworkImage(animal.images.first),
                          height: 160,
                          width: deviceWidth * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //tính toán khoảng cách
  Future<double> calculateDistance(
    currentAddress,
    otherAddress,
  ) async {
    LatLng currentP = LatLng(
      double.parse(currentAddress.latitude),
      double.parse(currentAddress.longitude),
    );

    LatLng pDestination = LatLng(
      double.parse(otherAddress.latitude),
      double.parse(otherAddress.longitude),
    );

    double distance = await Geolocator.distanceBetween(
      currentP.latitude,
      currentP.longitude,
      pDestination.latitude,
      pDestination.longitude,
    );

    return distance / 1000; // Chia cho 1000 để chuyển đổi sang đơn vị kilômét
  }
}


