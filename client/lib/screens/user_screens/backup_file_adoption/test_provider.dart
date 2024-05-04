import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/adoption_screen_giver.dart';
import 'package:provider/provider.dart';


// Step 1: Tạo một lớp Provider để lưu trữ trạng thái dữ liệu của Tab 2
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

class MyTabbedScreen extends StatefulWidget {
  @override
  _MyTabbedScreenState createState() => _MyTabbedScreenState();
}

class _MyTabbedScreenState extends State<MyTabbedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabbed Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1(),
          ChangeNotifierProvider(
            create: (_) => Tab2Data(), // Sử dụng Provider để lưu trữ trạng thái dữ liệu của Tab 2
            child: AdoptionScreenGiver(), // Sử dụng AdoptionScreenGiver trong Tab 2
          ),
        ],
      ),
    );
  }
}

class Tab1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to Tab1'),
    );
  }
}
