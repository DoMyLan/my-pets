import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/add_pet_personal_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:found_adoption_application/screens/filter_dialog.dart';

import 'package:hive/hive.dart';

class AdoptionScreenGiver extends StatefulWidget {
  const AdoptionScreenGiver({super.key});

  @override
  State<AdoptionScreenGiver> createState() => _AdoptionScreenGiverState();
}

class _AdoptionScreenGiverState extends State<AdoptionScreenGiver> {
  late List<Pet> animals = [];
  List<Pet> filteredAnimals = [];
  late var currentClient;
  bool isLoading = true;
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

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _searchController.clear();

    getClient() as dynamic;
    _searchController.addListener(_performSearch);
    futurePets = getAllPetPersonal();
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPetScreenPersonal(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

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
      height: 65,
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

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor:
          Theme.of(context).primaryColor, // Màu khi mục được chọn
      unselectedItemColor: Colors.grey, // Màu khi mục không được chọn
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.paw,
          ),
          label: 'Pet Center',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Personal',
        ),
      ],
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
            padding: const EdgeInsets.all(10),
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

  //SEARCH AND FILTER
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  // final Filter _filter = Filter(searchKeyword: '', petType: '', breed: '');

  List<Pet> _searchResults = []; // Danh sách kết quả tìm kiếm
  Future<List<Pet>>? futurePets;

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

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

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
      isLoading = false;
    });
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
                iconSize: 35,
              ),
              Text(
                'Filter',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAnimalAdopt() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.06),
      child: FutureBuilder<List<Pet>>(
        future: futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Please try again later'));
          } else {
            animals = snapshot.data ?? [];
            return Column(
              // Wrap Expanded with a Column
              children: [
                Expanded(child: buildAnimalList(animals, filteredAnimals)),
              ],
            );
          }
        },
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
              fontSize: 15,
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
          String distanceString = value.toStringAsFixed(2);
          print('khoảng cách: $distanceString');
        });

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AnimalDetailScreen(
                    animal: animal,
                    currentId: currentClient,
                  );
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 8, left: 10),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.mapMarkerAlt,
                                    color: Theme.of(context).primaryColor,
                                    size: 16.0,
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
                                            fontSize: 18,
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
                          height: 150,
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

class TBackHomePage extends StatelessWidget {
  const TBackHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(
        FontAwesomeIcons.bars,
        size: 25,
        color: Color.fromRGBO(48, 96, 96, 1.0),
      ),
      onTap: () async {
        var userBox = await Hive.openBox('userBox');
        var centerBox = await Hive.openBox('centerBox');

        var currentUser = userBox.get('currentUser');
        var currentCenter = centerBox.get('currentCenter');

        var currentClient = currentUser != null && currentUser.role == 'USER'
            ? currentUser
            : currentCenter;

        if (currentClient != null) {
          if (currentClient.role == 'USER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuFrameUser(
                  userId: currentClient.id,
                ),
              ),
            );
          } else if (currentClient.role == 'CENTER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuFrameCenter(
                  centerId: currentClient.id,
                ),
              ),
            );
          }
        }
      },
    );
  }
}

class TuserQuickInfor extends StatelessWidget {
  const TuserQuickInfor({
    super.key,
    required this.currentClient,
  });

  final currentClient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Location  ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    currentClient.address.split(',').length > 2
                        ? currentClient.address
                            .split(',')
                            .sublist(
                                currentClient.address.split(',').length - 2)
                            .join(',')
                        : currentClient.address,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AgePet {
  static String convertAge(DateTime birthday) {
    String age = '';
    DateTime now = DateTime.now();
    int months = now.month - birthday.month + 12 * (now.year - birthday.year);
    if (now.day < birthday.day) {
      months--;
    }

    if (months < 1) {
      // If age is less than 1 month, calculate in weeks
      int weeks = (now.difference(birthday).inDays / 7).floor();
      age = weeks.toString() + ' weeks';
    } else if (months < 12) {
      // If age is less than 1 year, calculate in months
      age = months.toString() + ' months';
    } else {
      // If age is 1 year or more, calculate in years and months
      int years = months ~/ 12;
      months %= 12;
      age = years.toString() + ' years ' + months.toString() + ' months';
    }

    return age;
  }
}

class AgeConverter {
  static String convertAge(double humanAge) {
    if (humanAge * 12 < 1) {
      // Nếu tuổi dưới 1 tháng, tính theo tuần
      return '${(humanAge * 52).toInt()} weeks';
    } else if (humanAge < 1) {
      // Nếu tuổi dưới 1 năm, tính theo tháng
      return '${(humanAge * 12).toInt()} months';
    } else {
      // Tuổi 1 năm trở lên, tính theo năm
      return '${humanAge.toInt()} years';
    }
  }
}
