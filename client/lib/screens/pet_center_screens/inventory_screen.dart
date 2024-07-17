import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet_inventory.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

// ignore: must_be_immutable
class LongTermStockPetsScreen extends StatefulWidget {
  const LongTermStockPetsScreen({super.key});

  @override
  State<LongTermStockPetsScreen> createState() =>
      _LongTermStockPetsScreenState();
}

class _LongTermStockPetsScreenState extends State<LongTermStockPetsScreen> {
  Future<List<PetInventory>>? petInventory;

  @override
  void initState() {
    super.initState();
    petInventory = getPetInventory(50);
  }

  late List<PetInventory> pets = [];

  int selectedDaysInStock = 50;
  final List<int> daysInStockOptions = [50, 100, 200, 500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tồn kho'),
        actions: <Widget>[
          DropdownButton<int>(
            value: selectedDaysInStock,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            elevation: 16,
            style: const TextStyle(color: Colors.grey),
            underline: Container(
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (int? newValue) {
              setState(() {
                selectedDaysInStock = newValue!;
                petInventory = getPetInventory(selectedDaysInStock);
              });
            },
            dropdownColor: Colors.white,
            items: daysInStockOptions.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Trên $value ngày',
                    style: TextStyle(color: Colors.grey[800]), // Đổi màu chữ
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder(
          future: petInventory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
              );
            }
            pets = snapshot.data as List<PetInventory>;
            for (var pet in pets) {
              pet.daysInStock = DateTime.now().difference(pet.createdAt).inDays;
            }

            if (pets.isEmpty) {
              return const Center(
                child: Text('Không có thú cưng nào'),
              );
            }

            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return GestureDetector(
                  onTap: () async {
                    dynamic currentClient = await getCurrentClient();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AnimalDetailScreen(
                          petId: pet.id, currentId: currentClient);
                    }));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                          width: 100, // Đặt chiều rộng cho hình ảnh
                          height: 100, // Đặt chiều cao cho hình ảnh
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(pet.image[0])),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(pet.name),
                            subtitle: Text(
                                '${pet.type} - Tồn kho ${pet.daysInStock} ngày'),
                            // Thêm một icon để thực hiện hành động, ví dụ: hiển thị menu
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
