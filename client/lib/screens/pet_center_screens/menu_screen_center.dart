import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/design_icon.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/screens/guest/home_guest.dart';
import 'package:found_adoption_application/screens/setting.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:hive/hive.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuCenterScreen extends StatefulWidget {
  final Function(int) menuCallBack;
  const MenuCenterScreen({super.key, required this.menuCallBack});

  @override
  State<MenuCenterScreen> createState() => _MenuCenterScreenState();
}

class _MenuCenterScreenState extends State<MenuCenterScreen> {
  int selectedMenuIndex = 0;
  int numNotify = 0;

  List<String> menuItems = [
    'Thú cưng',
    'Bài viết',
    'Cá nhân',
    'Thêm thú cưng',
    'Đơn hàng',
    // 'Manage Adopt',
    'Voucher',
    'Thông báo',

    // 'Messages',
  ];

  List<dynamic> icons = [];

  void updateIcons() {
    icons = [
      const Icon(FontAwesomeIcons.paw),
      const Icon(FontAwesomeIcons.newspaper),
      // ignore: deprecated_member_use
      const Icon(FontAwesomeIcons.userAlt),
      const Icon(FontAwesomeIcons.plus),
      CustomFirstOrderIcon(notificationCount: numNotify),

      // FontAwesomeIcons.checkToSlot,
      const Icon(FontAwesomeIcons.moneyBill),
      const Icon(FontAwesomeIcons.bell),
    ];

    // print("test numNotify: ${numNotify}");
  }

  @override
  void initState() {
    super.initState();

    _loadPreferences();
  }

  @override
  void didUpdateWidget(covariant MenuCenterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateIcons();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      numNotify = prefs.getInt('numNotify') ?? 0;
      updateIcons();
      // print("check numNotify: $numNotify");
    });
  }

  Future<void> _updateNotificationCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('numNotify', count);

    setState(() {
      numNotify = count;
      updateIcons();
    });

    // print("after click icon: ${prefs.getInt('numNotify')}");
  }

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          widget.menuCallBack(index);
          //CustomFirstOrderIcon- cập nhật numNotify về 0
          if (index == 4) {
            _updateNotificationCount(0);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            icons[index],
            const SizedBox(width: 5),
            Text(
              menuItems[index],
              style: TextStyle(
                color: selectedMenuIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the user tries to exit the app
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bạn có chắc muốn thoát khỏi ứng dụng?'),
            actions: [
              TextButton(
                child: const Text('Hủy'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Thoát'),
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
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                const Row(
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
                        padding: const EdgeInsets.only(right: 12),
                    
                        child: Row(
                          children: [
                            Icon(Icons.settings,
                                color: Colors.white.withOpacity(0.5)),
                            TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingScreen()),
                                  );
                                },
                                child: Text(
                                  'Khám phá',
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
                        padding: const EdgeInsets.only(left: 12),
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
                                  'Đăng xuất',
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
          title: const Text('Đăng xuất'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn đăng xuất không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đăng xuất'),
              onPressed: () async {
                Navigator.of(context).pop();
                //Navigate
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => Home_Guest_NoLogin())));

                var userBox = await Hive.openBox('userBox');
                await userBox.put('currentUser', null);

                var centerBox = await Hive.openBox('centerBox');
                await centerBox.put('currentCenter', null);
                // Code to logout the user goes here
              },
            ),
          ],
        );
      },
    );
  }
}
