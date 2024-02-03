import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/adoption_screen_giver.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = const [
    AdoptionScreen(centerId: null,),
    AdoptionScreenGiver(),
  ];

  final pageTitle = const [
    'Pet Center',
    'Personal',
  ];

  void _onNavigationItemSelected(index) {
    title.value = pageTitle[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (BuildContext context, int value, _) {
            return pages[value];
          },
        ),
        bottomNavigationBar: _BottomNavigationBar(
          onItemSelected: _onNavigationItemSelected,
        ));
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({required this.onItemSelected});

  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {

    final brightness = Theme.of(context).brightness;

    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent: null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8 ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavigationBarItem(
                  index: 0,
                  lable: 'Pet Center',
                  icon: Icons.pets,
                  isSelected: (selectedIndex == 0),
                  onTap: handleItemSelected,
                ),
                _NavigationBarItem(
                  index: 1,
                  lable: 'Personal',
                  icon: FontAwesomeIcons.user,
                  isSelected: (selectedIndex == 1),
                  onTap: handleItemSelected,
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem(
      {required this.index,
      required this.lable,
      required this.icon,
      this.isSelected = false,
      required this.onTap});

  final int index;
  final String? lable;
  final IconData? icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
            const SizedBox(height: 8),
            Text(
              lable!,
              style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                  fontWeight: isSelected ? FontWeight.bold : null),
            ),
          ],
        ),
      ),
    );
  }
}
