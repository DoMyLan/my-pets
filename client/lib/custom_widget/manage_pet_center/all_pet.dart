import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllPetCenter extends StatefulWidget {
  final String listType;
  final String searchKeyword;
  final List<Pet>? filterResult;
  final ValueChanged<String> onSearchKeywordChanged;
  AllPetCenter(
      {required this.listType,
      required this.searchKeyword,
      required this.onSearchKeywordChanged,
      required this.filterResult});
  @override
  _AllPetCenterState createState() => _AllPetCenterState();
}

class _AllPetCenterState extends State<AllPetCenter>
    with AutomaticKeepAliveClientMixin<AllPetCenter> {
  late var currentClient;
  Future<List<Pet>>? futurePets;
  String _searchKeyword = '';

  late List<Pet> previousPets = []; // Dữ liệu của pets trước đó
  late bool dataFetched =
      false; // Biến trạng thái để kiểm tra liệu dữ liệu đã được fetch hay chưa
  bool isLoading = true;
  late List<Pet> animals = [];
  List<Pet> _searchResults = [];

  //khai báo danh sách các pet
  late List<Pet> forSale = [];
  late List<Pet> pending = [];
  late List<Pet> sold = [];
  late List<Pet>? filter;

  Future<void> fetchPets() async {
    try {
      var temp = await getCurrentClient();
      setState(() {
        currentClient = temp;

        isLoading = false;
      });

      var pets = await getAllPet();
      if (!listEquals(pets, previousPets)) {
        // Nếu dữ liệu mới khác dữ liệu trước đó, cập nhật dữ liệu trước đó và hiển thị dữ liệu mới
        setState(() {
          previousPets = List.from(pets);
          animals = List.from(pets);
          dataFetched =
              true; // Đặt biến trạng thái thành true sau khi dữ liệu đã được fetch

          forSale =
              animals.where((pet) => pet.statusPaid == 'NOTHING').toList();
          pending =
              animals.where((pet) => pet.statusPaid == 'PENDING').toList();
          sold = animals.where((pet) => pet.statusPaid == 'PAID').toList();
        });
      }
    } catch (error) {
      // Xử lý lỗi
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.filterResult != null) {
      filter = widget.filterResult!;
      print('aaaaaa: $filter');
    } else {
      filter = null;
    }
    _searchKeyword = widget.searchKeyword;
    fetchPets();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(AllPetCenter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchKeyword != widget.searchKeyword) {
      setState(() {
        _searchKeyword = widget.searchKeyword;
        _performSearch();
      });
    }

    if (oldWidget.filterResult != widget.filterResult) {
      setState(() {
        filter = widget.filterResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('test searchKeyWord02: $_searchKeyword');
    List<Pet> listToShow;
    if (filter != null) {
      listToShow = filter!;
    } else {
      switch (widget.listType) {
        case 'forSale':
          listToShow = forSale;
          break;
        case 'pending':
          listToShow = pending;
          break;
        case 'sold':
          listToShow = sold;
          break;
        case 'filter':
          listToShow = filter!;
          break;
        default:
          listToShow = animals;
      }
    }
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
                  return buildAnimalList(listToShow);
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildAnimalList(List<Pet> animals) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount:
          _searchKeyword.isEmpty ? animals.length : _searchResults.length,
      itemBuilder: (context, index) {
        final animal =
            _searchKeyword.isEmpty ? animals[index] : _searchResults[index];

        calculateDistance(currentClient.location, animal.centerId!.location)
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
                                  fieldInforPet('Tên', animal.namePet),
                                  Icon(
                                    animal.gender == "FEMALE"
                                        ? FontAwesomeIcons.venus
                                        : FontAwesomeIcons.mars,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              fieldInforPet('Giống', animal.breed),
                              const SizedBox(height: 2),
                              fieldInforPet(
                                  'Tuổi',
                                  animal.birthday != null
                                      ? AgePet.convertAge(animal.birthday!)
                                      : "Không xác định"),
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
                                    '       ${animal.price} VND',
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
                              const SizedBox(height: 4),
                              if (currentClient.role == 'USER')
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      color: Theme.of(context).primaryColor,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 1),
                                    Text(
                                      'Khoảng cách: ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    FutureBuilder<double>(
                                      future: calculateDistance(
                                          currentClient.location,
                                          animal.centerId!.location),
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
                                              color: Theme.of(context)
                                                  .primaryColor,
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

  void _performSearch() {
    setState(() {
      _searchResults = animals
          .where((pet) =>
              pet.breed.toLowerCase().contains(_searchKeyword.toLowerCase()))
          .toList();
    });
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
      age = weeks.toString() + ' tuần';
    } else if (months < 12) {
      // If age is less than 1 year, calculate in months
      age = months.toString() + ' tháng';
    } else {
      // If age is 1 year or more, calculate in years and months
      int years = months ~/ 12;
      months %= 12;
      age = years.toString() + ' năm ' + months.toString() + ' tháng';
    }

    return age;
  }
}

class AgeConverter {
  static String convertAge(double humanAge) {
    if (humanAge * 12 < 1) {
      // Nếu tuổi dưới 1 tháng, tính theo tuần
      return '${(humanAge * 52).toInt()} tuần';
    } else if (humanAge < 1) {
      // Nếu tuổi dưới 1 năm, tính theo tháng
      return '${(humanAge * 12).toInt()} tháng';
    } else {
      // Tuổi 1 năm trở lên, tính theo năm
      return '${humanAge.toInt()} năm';
    }
  }
}
