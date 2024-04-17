// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:found_adoption_application/screens/adoption_screen.dart';
// import 'package:found_adoption_application/screens/adoption_screen_giver.dart';
// import 'package:found_adoption_application/screens/user_screens/add_pet_personal_screen.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final ValueNotifier<int> pageIndex = ValueNotifier(0);
//   final ValueNotifier<String> title = ValueNotifier('Messages');

//   final pages = const [
//     AdoptionScreen(
//       centerId: null,
//     ),
//     AddPetScreenPersonal(),
//     AdoptionScreenGiver(),
//   ];

//   final pageTitle = const [
//     'Pet Center',
//     '',
//     'Personal',
//   ];

//   void _onNavigationItemSelected(index) {
//     title.value = pageTitle[index];
//     pageIndex.value = index;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           ValueListenableBuilder(
//             valueListenable: pageIndex,
//             builder: (BuildContext context, int value, _) {
//               return pages[value];
//             },
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   border: Border.all(
//                     color: Colors.grey.withOpacity(0.5),
//                     width: 1.0,
//                   ),
//                 ),
//                 child: _BottomNavigationBar(
//                   onItemSelected: _onNavigationItemSelected,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BottomNavigationBar extends StatefulWidget {
//   const _BottomNavigationBar({required this.onItemSelected});

//   final ValueChanged<int> onItemSelected;

//   @override
//   State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
// }

// class _BottomNavigationBarState extends State<_BottomNavigationBar> {
//   var selectedIndex = 0;

//   void handleItemSelected(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//     widget.onItemSelected(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final brightness = Theme.of(context).brightness;

//     return Card(
//       color: (brightness == Brightness.light) ? Colors.transparent : null,
//       elevation: 0,
//       margin: const EdgeInsets.only(top: 4),
//       child: SafeArea(
//         top: false,
//         bottom: true,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _NavigationBarItem(
//               index: 0,
//               lable: 'Pet Center',
//               icon: Icons.pets,
//               isSelected: (selectedIndex == 0),
//               onTap: handleItemSelected,
//             ),
//             _NavigationBarItem(
//               index: 1,
//               lable: '',
//               icon: Icons.add,
//               isSelected: (selectedIndex == 1),
//               onTap: handleItemSelected,
//             ),
//             _NavigationBarItem(
//               index: 2,
//               lable: 'Personal',
//               icon: FontAwesomeIcons.user,
//               isSelected: (selectedIndex == 2),
//               onTap: handleItemSelected,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NavigationBarItem extends StatelessWidget {
//   const _NavigationBarItem(
//       {required this.index,
//       required this.lable,
//       required this.icon,
//       this.isSelected = false,
//       required this.onTap});

//   final int index;
//   final String? lable;
//   final IconData? icon;
//   final bool isSelected;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         onTap(index);
//       },
//       child: SizedBox(
//         width: 70,
//         height: 45,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color: isSelected ? Colors.white : null,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               lable!,
//               style: TextStyle(
//                   fontSize: 11,
//                   color: isSelected ? Colors.white : null,
//                   fontWeight: isSelected ? FontWeight.bold : null),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/adoption_screen_giver.dart';
import 'package:found_adoption_application/screens/user_screens/add_pet_personal_screen.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Pet Center",
        useSafeArea: true,
        labels: const ["Pet Center", "Add Pet", "Personal"],
        icons: const [Icons.pets, Icons.add, FontAwesomeIcons.user],
        tabSize: 50,
        tabBarHeight: 50,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Theme.of(context).primaryColor,
        tabIconSize: 18.0,
        tabIconSelectedSize: 16.0,
        tabSelectedColor: Theme.of(context).primaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: const [
          AdoptionScreen(
            centerId: null,
          ),
          AddPetScreenPersonal(),
          AdoptionScreenGiver(),
        ],
      ),
    );
  }
}
