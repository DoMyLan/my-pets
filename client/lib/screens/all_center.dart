import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/center_item.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/models/center_hot_model.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class AllCenterScreen extends StatefulWidget {
  @override
  State<AllCenterScreen> createState() => _AllCenterScreenState();
}

class _AllCenterScreenState extends State<AllCenterScreen> {
  Future<List<CenterHot>>? centerHotFuture;
  List<CenterHot> centerHots = [];
  dynamic currentClient;

  @override
  void initState() {
    super.initState();
    centerHotFuture = getCenterHot();
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
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

              FutureBuilder(
                  future: centerHotFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      centerHots = snapshot.data as List<CenterHot>;

                      if (currentClient.role == "USER") {
                        for (var centerHot in centerHots) {
                          centerHot.follow =
                              centerHot.followerUser.contains(currentClient.id);
                          centerHot.follower = centerHot.followerUser.length +
                              centerHot.followerCenter.length;
                        }
                      } else {
                        for (var centerHot in centerHots) {
                          centerHot.follow = centerHot.followerCenter
                              .contains(currentClient.id);
                          centerHot.follower = centerHot.followerUser.length +
                              centerHot.followerCenter.length;
                        }
                      }

                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                            itemCount: centerHots.length,
                            itemBuilder: (context, index) {
                              return CenterItem(
                                centerHot: centerHots[index],
                              );
                            }),
                      );
                    }
                  }),
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
