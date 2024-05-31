import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/pet_sale_model.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/guest/widget.dart';
import 'package:found_adoption_application/screens/payment_screen.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class PetsSale extends StatefulWidget {
  final List<PetSale> listPetSale;
  const PetsSale({super.key, required this.listPetSale});

  @override
  State<PetsSale> createState() => _PetsSaleState();
}

class _PetsSaleState extends State<PetsSale> {
  List<PetSale> listPetSale = [];
  dynamic currentClient;

  @override
  void initState() {
    super.initState();
    getClient();
    listPetSale = widget.listPetSale;
  }

  Future<void> getClient() async {
    dynamic client = await getCurrentClient();
    setState(() {
      currentClient = client;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(
            "Thú cưng đang được giảm giá",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: listPetSale.length < 10 ? listPetSale.length : 10,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AnimalDetailScreen(
                    petId: listPetSale[index].id,
                    currentId: currentClient,
                  );
                }));
              },
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(children: [
                    Container(
                      height: 200.0,
                      width: 230.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(listPetSale[index].image),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      height: 200.0,
                      width: 230.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.9)
                              ])),
                    ),
                    SizedBox(
                      height: 200,
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(listPetSale[index].name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis)),
                                Text(
                                  " - ${listPetSale[index].breed}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      overflow: TextOverflow.fade),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("${listPetSale[index].price}đ",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2.0,
                                            decorationColor: Colors.white)),
                                    Text(
                                        "${listPetSale[index].price - listPetSale[index].reducePrice > 0 ? listPetSale[index].price - listPetSale[index].reducePrice : "Miễn phí"}đ",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const Spacer(),
                                OnPressBuyWidget(
                                    petSale: listPetSale[index],
                                    currentClient: currentClient),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
            );
          }),
    );
  }
}

class OnPressBuyWidget extends StatefulWidget {
  final PetSale petSale;
  final dynamic currentClient;

  const OnPressBuyWidget({
    super.key,
    required this.petSale,
    required this.currentClient,
  });

  @override
  State<OnPressBuyWidget> createState() => _OnPressBuyWidgetState();
}

class _OnPressBuyWidgetState extends State<OnPressBuyWidget> {
  late bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        Pet pet = await getPet(widget.petSale.id);
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PaymentScreen(pet: pet, currentClient: widget.currentClient);
        }));
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.teal[300]),
        child: isLoading
            ? const OnPressedButton(size: 20, strokeWidth: 3)
            : const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 25,
              ),
      ),
    );
  }
}
