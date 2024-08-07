import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/guest/home_guest.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:hive/hive.dart';
import '../../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuUserScreen extends StatefulWidget {
  final Function(int) menuCallBack;
  const MenuUserScreen({super.key, required this.menuCallBack});

  @override
  State<MenuUserScreen> createState() => _MenuUserScreenState();
}

class _MenuUserScreenState extends State<MenuUserScreen> {
  int selectedMenuIndex = 0;

  List<String> menuItems = [
    'Trang chủ',
    'Thú cưng',
    'Cá nhân',
    'Bài viết',
    'Yêu thích',
    'Đơn hàng',
    // 'Manage Adopt',
    'Thông báo',
    // 'Favorite',
    // 'Messages',

    // 'Short Videos'
  ];

  List<IconData> icons = [
    // ignore: deprecated_member_use
    FontAwesomeIcons.home,
    FontAwesomeIcons.paw,
    // ignore: deprecated_member_use
    FontAwesomeIcons.userAlt,
    FontAwesomeIcons.newspaper,
    FontAwesomeIcons.heart,

    FontAwesomeIcons.checkToSlot,
    FontAwesomeIcons.bell,

    // FontAwesomeIcons.envelope,
    // FontAwesomeIcons.radio
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
        padding: const EdgeInsets.symmetric(vertical: 24),
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
                        future: getCurrentClient().then((currentClient) =>
                            currentClient.firstName +
                            ' ' +
                            currentClient.lastName),
                        builder: (context, snapshotName) {
                          if (snapshotName.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshotName.hasError) {
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
                        // ignore: avoid_types_as_parameter_names
                        .map((MapEntry) => buildMenuRow(MapEntry.key))
                        .toList(),
                  ),
                  Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          color: Colors.white.withOpacity(0.5)),
                      TextButton(
                          onPressed: () async {
                            _showLogoutDialog(context);

                            //Close Hive
                            // await Hive.close();
                          },
                          child: Text(
                            '   Đăng xuất',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ))
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Home_Guest_NoLogin())));

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
