import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/adoption_free_screen.dart';
import 'package:found_adoption_application/screens/adoption_screen.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:provider/provider.dart';

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
        initialSelectedTab: "Thú cưng",
        useSafeArea: true,
        labels: const ["Thú cưng", "Miễn phí"],
        icons: const [Icons.pets, FontAwesomeIcons.handHoldingHeart],
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
        children: [
          ChangeNotifierProvider(
            create: (_) => Tab2Data(),
            child: AdoptionScreen(
              centerId: null,
            ),
          ),
          // AddPetScreenPersonal(),
          ChangeNotifierProvider(
            create: (_) => Tab2Data(),
            child: AdoptionFreeScreen(
              centerId: null,
            ),
          ),
        ],
      ),
    );
  }
}

class Tab2Data extends ChangeNotifier {
  //dữ liệu chưa đc fetch
  bool _dataFetched = false;

  //cho phép các wiget khác truy cập _dataFetched
  bool get dataFetched => _dataFetched;

  // Phương thức để cập nhật trạng thái dữ liệu
  void updateDataFetched(bool fetched) {
    _dataFetched = fetched;
    notifyListeners();
  }
}
