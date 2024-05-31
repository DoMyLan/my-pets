import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/age.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PetBreed extends StatefulWidget {
  final String breed;
  const PetBreed({super.key, required this.breed});

  @override
  State<PetBreed> createState() => _PetBreedState();
}

class _PetBreedState extends State<PetBreed> {
  Future<List<Pet>>? pets;
  List<Pet> animals = [];
  dynamic currentClient;

  @override
  void initState() {
    super.initState();
    getClient();
    pets = getPetBreed(widget.breed);
  }

  Future<void> getClient() async {
    currentClient = await getCurrentClient();
    setState(() {
      currentClient = currentClient;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.breed),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: FutureBuilder(
          future: pets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              animals = snapshot.data as List<Pet>;

              if (animals.isEmpty) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.pets,
                      color: Colors.blue,
                      size: 50,
                    ),
                    SizedBox(width: 10),
                    Text('Không có thú cưng nào',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ],
                ));
              }

              return ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  calculateDistance(currentClient.location,
                          animals[index].centerId!.location)
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
                              petId: animals[index].id,
                              currentId: currentClient,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 6, right: 4, left: 12),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.4),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            fieldInforPet(
                                                'Tên', animals[index].namePet),
                                            Icon(
                                              animals[index].gender == "FEMALE"
                                                  ? FontAwesomeIcons.venus
                                                  : FontAwesomeIcons.mars,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        fieldInforPet(
                                            'Giống', animals[index].breed),
                                        const SizedBox(height: 2),
                                        fieldInforPet(
                                            'Tuổi',
                                            animals[index].birthday != null
                                                ? AgePet.convertAge(
                                                    animals[index].birthday!)
                                                : "Không xác định"),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons
                                                  .handHoldingDollar,
                                              color: Colors.grey,
                                              size: 16.0,
                                            ),
                                            const SizedBox(width: 1),
                                            Text(
                                              '       ${animals[index].price} VND',
                                              // '      2350000.vnd',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (currentClient.role == 'USER')
                                          Row(
                                            children: [
                                              Icon(
                                                // ignore: deprecated_member_use
                                                FontAwesomeIcons.mapMarkerAlt,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 14.0,
                                              ),
                                              const SizedBox(width: 1),
                                              Text(
                                                'Khoảng cách: ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              FutureBuilder<double>(
                                                future: calculateDistance(
                                                    currentClient.location,
                                                    animals[index]
                                                        .centerId!
                                                        .location),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                        'Calculating...');
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Text('Error');
                                                  } else {
                                                    String distanceString =
                                                        snapshot.data!
                                                            .toStringAsFixed(2);
                                                    return Text(
                                                      '$distanceString km',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w800,
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
                                  tag: animals[index].namePet,
                                  child: Image(
                                    image: NetworkImage(
                                        animals[index].images.first),
                                    height: 160,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,
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
          }),
    );
  }

  Widget fieldInforPet(String infor, String inforDetail) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$infor: ',
            style: const TextStyle(
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

    double distance = Geolocator.distanceBetween(
      currentP.latitude,
      currentP.longitude,
      pDestination.latitude,
      pDestination.longitude,
    );

    return distance / 1000; // Chia cho 1000 để chuyển đổi sang đơn vị kilômét
  }
}
