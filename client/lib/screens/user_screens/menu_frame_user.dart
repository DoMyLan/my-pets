import 'package:flutter/material.dart';

import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/screens/menu_adoption.dart';
import 'package:found_adoption_application/screens/notify.dart';
import 'package:found_adoption_application/screens/pet_favorites.dart';
import 'package:found_adoption_application/screens/user_screens/menu_screen_user.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/screens/user_screens/status_adopt.dart';

class MenuFrameUser extends StatefulWidget {
  final userId;
  const MenuFrameUser({super.key, required this.userId});

  @override
  State<MenuFrameUser> createState() => _MenuFrameUserState();
}

class _MenuFrameUserState extends State<MenuFrameUser>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Duration duration = Duration(microseconds: 200);
  // late Animation<double> scaleAnimation, smallerScaleAnimation;
  bool menuOpen = true;
  late List<Animation<double>> scaleAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);

    scaleAnimations = [
      Tween<double>(begin: 1.0, end: 0.7).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.6).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.5).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.0).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.0).animate(_animationController),
      Tween<double>(begin: 1.0, end: 0.0).animate(_animationController),
    ];

    //hoạt ảnh chạy từ begin -> end
    _animationController.forward();

    //sao chép danh sách screens vào screensnapshot
    screenSnapshot = screens.values.toList();
    screens[2] = ProfilePage(userId: widget.userId);
  }

  //Map chứa cặp key-value (int - widget)
  Map<int, Widget> screens = {
    0: HomeScreen(),
    1: PetFavorites(),
    2: FeedScreen(),
    3: ProfilePage(userId: null),
    4: StatusAdoptUser(),
    5: NotificationPage()
  };

  late List<Widget> screenSnapshot;

  List<Widget> finalStack() {
    List<Widget> stackToReturn = [];
    stackToReturn.add(MenuUserScreen(
      menuCallBack: (selectedIndex) {
        setState(() {
          screenSnapshot = screens.values.toList();
          final selectedWidget = screenSnapshot.removeAt(selectedIndex);

          //chèn screen được chọn lên vtri đầu tiên
          screenSnapshot.insert(0, selectedWidget);
          menuOpen = false;
          _animationController.reverse();
        });
      },
    ));

    screenSnapshot
        //Map chứa key-value. Trong đó key(vitri màn hình), value (màn hình tương ứng)
        .asMap()
        .entries
        .map((screenEntry) => buildScreenStack(screenEntry
            .key)) //gọi đến buildScreenStack để tạo widget tương ứng với key (int)
        .toList()
        .reversed
        .forEach((screen) {
      stackToReturn.add(screen);
    });

    return stackToReturn;
  }

  Widget buildScreenStack(int position) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        left: menuOpen ? deviceWidth * 0.55 - (position * 50) : 0.0,
        right: menuOpen ? deviceWidth * -0.45 + (position * 50) : 0.0,
        bottom: 0,
        child: ScaleTransition(
            scale: scaleAnimations[position],
            //wiget này đc sử dụng xử lý thao tac chạm như kéo, vuốt, nhấn giữ,...
            child: GestureDetector(
              onTap: () {
                if (menuOpen) {
                  setState(() {
                    menuOpen = false;

                    //hoạt ảnh chạy ngược từ end -> begin
                    _animationController.reverse();
                  });
                }
              },
              child: AbsorbPointer(
                absorbing: menuOpen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(menuOpen ? 50 : 0),
                  child: Material(
                    animationDuration: duration,
                    child: screenSnapshot[position],
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(children: finalStack());
  }
}
