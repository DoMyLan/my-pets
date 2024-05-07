import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/services/center/petApi.dart';

class FilterDialog extends StatefulWidget {
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'Chọn bộ lọc',
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // const Spacer(), 
          IconButton(
            icon: const Icon(Icons.clear_outlined, color: Colors.black, size: 20,),
            onPressed: () {
              // Xử lý khi bấm nút clear
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedBreed ='Chó cỏ';
  RangeValues selectedAgeRange = RangeValues(1, 10);
  List<String> selectedColors = [];
  List<String> allColors = [
    'Đen',
    'Trắng',
    'Đỏ',
    'Vàng',
    'Hồng',
    'Nâu',
    'Xám',
    'Khác'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn giống:'),
            DropdownButton<String>(
              value: selectedBreed,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBreed = newValue;
                  });
                }
              },
              items: <String>[
                'Husky',
                'Poodle',
                'Pitpull',
                'Chó cỏ',
                'Mèo ta',
                'Mèo Anh lông ngắn',
                'Khác'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
                'Chọn độ tuổi: ${selectedAgeRange.start.toInt()} - ${selectedAgeRange.end.toInt()} năm'),
            RangeSlider(
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey,
              values: selectedAgeRange,
              min: 0,
              max: 10,
              onChanged: (RangeValues values) {
                setState(() {
                  selectedAgeRange = values;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Chọn màu sắc:'),
            Column(
              children: allColors.map((String color) {
                return CheckboxListTile(
                  title: Text(color),
                  value: selectedColors.contains(color),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedColors.add(color);
                        } else {
                          selectedColors.remove(color);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                try {
                  List<int> listAge =
                      convertRangeValuesToListInt(selectedAgeRange);

                  Future<List<Pet>> dataPet =
                      filterPet(selectedBreed, selectedColors, listAge);
                  Navigator.pop<Future<List<Pet>>>(context, dataPet);
                } catch (e) {
                  print('errorr12: ${e.toString()}');
                }
              },
              child: Text(
                'Áp dụng',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> convertRangeValuesToListInt(RangeValues values) {
    int start = values.start.round();
    int end = values.end.round();
    return List<int>.generate(end - start + 1, (i) => i + start);
  }
}
