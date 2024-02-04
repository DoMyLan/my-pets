import 'package:flutter/material.dart';

class Pet {
  final String name;
  final String species;
  final String description;
  final String imageUrl;

  Pet({required this.name, required this.species, required this.description, required this.imageUrl});
}



class PetFound extends StatelessWidget {
  final List<Pet> pets = [
    Pet(name: 'Cat 1', species: 'Cat', description: 'Cute cat with green eyes', imageUrl: 'https://example.com/cat1.jpg'),
    Pet(name: 'Dog 1', species: 'Dog', description: 'Friendly dog with brown fur', imageUrl: 'https://example.com/dog1.jpg'),
    // Add more pets as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm Pet Thất Lạc'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pets[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailPage(pet: pets[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PetDetailPage extends StatelessWidget {
  final Pet pet;

  PetDetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(pet.imageUrl),
            SizedBox(height: 16),
            Text('Name: ${pet.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Species: ${pet.species}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Description: ${pet.description}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
