import 'package:flutter/material.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/screens/setting.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:hive/hive.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuCenterScreen extends StatefulWidget {
  final Function(int) menuCallBack;
  MenuCenterScreen({super.key, required this.menuCallBack});

  @override
  State<MenuCenterScreen> createState() => _MenuCenterScreenState();
}

class _MenuCenterScreenState extends State<MenuCenterScreen> {
  int selectedMenuIndex = 0;

  List<String> menuItems = [
    'Buy Pet',
    'Pet Story',
    'Profile',
    'Add pet',
    'Order',
    // 'Manage Adopt',
    ' Add Voucher',
    
    // 'Messages',

  
  ];

  List<IconData> icons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.newspaper,
    FontAwesomeIcons.userAlt,
    FontAwesomeIcons.plus,
    FontAwesomeIcons.firstOrder,
    // FontAwesomeIcons.checkToSlot,
    FontAwesomeIcons.moneyBill,
 
    // FontAwesomeIcons.envelope,

 
  ];

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          widget.menuCallBack(index);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: selectedMenuIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 5),
            Text(
              menuItems[index],
              style: TextStyle(
                  color: selectedMenuIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the user tries to exit the app
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure you want to exit the application?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Exit'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );

        return shouldExit ?? false; // Return false if shouldExit is null
      },
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startingColor, mainColor],
          )),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FutureBuilder(
                        // Trả về một Future có kiểu dữ liệu là String (URL của avatar)
                        future: getCurrentClient()
                            .then((currentClient) => currentClient.avatar),
                        builder: (context, snapshotAvatar) {
                          if (snapshotAvatar.connectionState ==
                              ConnectionState.waiting) {
                            // Hiển thị một vòng tròn chờ nếu đang tải dữ liệu
                            return const CircleAvatar(
                              radius: 24.0,
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshotAvatar.hasError) {
                            // Xử lý lỗi nếu có
                            return Text('Error: ${snapshotAvatar.error}');
                          } else {
                            // Hiển thị CircleAvatar khi dữ liệu avatar sẵn sàng
                            return CircleAvatar(
                              radius: 24.0,
                              backgroundImage:
                                  NetworkImage(snapshotAvatar.data!),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      FutureBuilder(
                        // Trả về một Future có kiểu dữ liệu là String (tên trung tâm)
                        future: getCurrentClient()
                            .then((currentClient) => currentClient.name),
                        builder: (context, snapshotName) {
                          if (snapshotName.connectionState ==
                              ConnectionState.waiting) {
                            // Hiển thị một vòng tròn chờ nếu đang tải dữ liệu
                            return const CircularProgressIndicator();
                          } else if (snapshotName.hasError) {
                            // Xử lý lỗi nếu có
                            return Text('Error: ${snapshotName.error}');
                          } else {
                            // Hiển thị tên trung tâm khi dữ liệu tên sẵn sàng
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshotName.data!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Đang hoạt động',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: menuItems
                        .asMap()
                        .entries
                        .map((MapEntry) => buildMenuRow(MapEntry.key))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    //Phần SETTING
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Row(
                          children: [
                            Icon(Icons.settings,
                                color: Colors.white.withOpacity(0.5)),
                            TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingScreen()),
                                  );
                                },
                                child: Text(
                                  'Setting',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                      ),

                      Text(
                        '||',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: Colors.white.withOpacity(0.5)),
                            TextButton(
                                onPressed: () async {
                                  _showLogoutDialog(context);
                                },
                                child: Text(
                                  'Log out',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are about to log out. Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log out'),
              onPressed: () async {
                Navigator.of(context).pop();
                //Navigate
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => LoginScreen())));

                var userBox = await Hive.openBox('userBox');
                await userBox.put('currentUser', null);

                var centerBox = await Hive.openBox('centerBox');
                await centerBox.put('currentCenter', null);
              },
            ),
          ],
        );
      },
    );
  }
}
