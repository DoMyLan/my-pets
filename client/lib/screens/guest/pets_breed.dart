import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/breed_model.dart';
import 'package:found_adoption_application/screens/pet_breed.dart';

class PetsBreed extends StatefulWidget {
  final String type;
  final List<Breed> breeds;
  const PetsBreed({super.key, required this.breeds, required this.type});

  @override
  State<PetsBreed> createState() => _PetsBreedState();
}

class _PetsBreedState extends State<PetsBreed> {
  List<Breed> breeds = [];

  @override
  void initState() {
    super.initState();
    breeds = widget.breeds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
            widget.type,
            style: const TextStyle(
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
              crossAxisCount: 3),
          itemCount: breeds.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PetBreed(
                    breed: breeds[index].name,
                  );
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Stack(children: [
                    Image(
                      image: AssetImage(breeds[index].asset),
                      height: 180.0,
                      width: 130.0,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 180.0,
                      width: 130.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.8)
                          ])),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              breeds[index].name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  breeds[index].view.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  breeds[index].sold.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            )
                          ]),
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}
