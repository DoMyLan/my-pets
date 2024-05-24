import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/center_item.dart';
import 'package:found_adoption_application/main.dart';

class AllCenterScreen extends StatefulWidget {
  @override
  State<AllCenterScreen> createState() => _AllCenterScreenState();
}

class _AllCenterScreenState extends State<AllCenterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        title: const Text('Danh sách các Center'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Nhập mã voucher
              buildSearchBar(),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey.shade300,
                height: 8,
                thickness: 1,
              ),

              const SizedBox(
                height: 4,
              ),

              CenterItem(),
              SizedBox(
                height: 10,
              ),

              CenterItem(),
              SizedBox(
                height: 10,
              ),

              CenterItem(),
              SizedBox(
                height: 10,
              ),

              CenterItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0), // Giảm giá trị vertical để làm cho SearchBar nhỏ lại
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
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
                      // controller: _searchController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Tìm thú cưng',
                        contentPadding: EdgeInsets.symmetric(
                            vertical:
                                8), // Giảm khoảng cách giữa các phần tử trong vùng nhập
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.swap_vert),
                color: mainColor,
                onPressed: () {},
                iconSize: 30,
              ),
              Text(
                'Khoảng cách',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllCenterScreen(),
  ));
}
