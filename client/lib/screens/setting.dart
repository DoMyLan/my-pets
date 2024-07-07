import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/change_password.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/revenue/revenue_statistic.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  dynamic currentClient;
  @override
  void initState() {
    super.initState();
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  int selectedMenuIndex = 0;

  List<String> menuItems = [
    'Sửa thông tin cá nhân',
    'Đổi mật khẩu',
    'Doanh thu',
  ];

  List<IconData> icons = [
    FontAwesomeIcons.userAlt,
    FontAwesomeIcons.lockOpen,
    Icons.show_chart_sharp,
  ];

  List<Widget> menuScreens = [
    EditProfileCenterScreen(),
    UpdatePasswordScreen(),
    RevenueReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(48, 96, 96, 1.0),
          centerTitle: true,
          title: const Text(
            'Chức năng thêm',
            style: TextStyle(
                fontSize: 17, color: Colors.white, letterSpacing: 0.53),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: InkWell(
            onTap: () async {
              var currentClient = await getCurrentClient();

              if (currentClient != null) {
                if (currentClient.role == 'USER') {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuFrameUser(
                        userId: currentClient.id,
                      ),
                    ),
                  );
                } else if (currentClient.role == 'CENTER') {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MenuFrameCenter(centerId: currentClient.id),
                    ),
                  );
                }
              }
            },
            child: const Icon(
              Icons.subject,
              color: Colors.white,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.settings,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
              child: getAppBottomView(currentClient),
              preferredSize: const Size.fromHeight(110.0)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              if (index != 0) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    buildMenuRow(index),
                  ],
                );
              } else {
                return buildMenuRow(index);
              }
            },
          ),
        ));
  }

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          // Đưa vào hàm callback nếu cần
          menuCallBack(index);
        });
      },
      child: ListTile(
        leading: Icon(icons[index]),
        minLeadingWidth: 20,
        minVerticalPadding: 20,
        title: Text(menuItems[index]),
        selected: index == selectedMenuIndex,
        selectedTileColor:
            Colors.blue.withOpacity(0.5), // Màu nền khi mục được chọn
      ),
    );
  }

  void menuCallBack(int index) {
    // Xử lý sự kiện khi mục được chọn
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => menuScreens[index]),
    );
  }
}

Widget getAppBottomView(currentClient) {
  return Container(
    padding: const EdgeInsets.only(left: 30, bottom: 20),
    child: Row(
      children: [
        getProfileView(currentClient),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentClient.role == 'CENTER'
                    ? currentClient.name
                    : currentClient.firstName + ' ' + currentClient.lastName,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                currentClient.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                currentClient.phoneNumber,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget getProfileView(currentClient) {
  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle, // Đây là điểm chính để đảm bảo hình dạng tròn
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.network(currentClient.avatar,
                fit: BoxFit.cover,
                width: 64,
                height: 64), // Đảm bảo hình ảnh vừa vặn
          ),
        ),
      ),
      Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            height: 30,
            width: 30,
            child: const Icon(
              Icons.edit,
              color: Color.fromRGBO(48, 96, 96, 1.0),
              size: 20,
            ),
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ))
    ],
  );
}
