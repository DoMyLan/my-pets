import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/revenue/paid_tab.dart';
import 'package:found_adoption_application/screens/revenue/unpaid_tab.dart';


class RevenueReportScreen extends StatefulWidget {
  @override
  _RevenueReportScreenState createState() => _RevenueReportScreenState();
}

class _RevenueReportScreenState extends State<RevenueReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Revenue Report'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chưa thanh toán'),
            Tab(text: 'Đã thanh toán'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UnpaidTab(),
          PaidTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


void main() {
 
  runApp(MaterialApp(
    
    home: RevenueReportScreen(),
  ));
}
