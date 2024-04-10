import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/order/statisticalApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyRevenueChart extends StatefulWidget {
  @override
  State<MonthlyRevenueChart> createState() => _MonthlyRevenueChartState();
}

class _MonthlyRevenueChartState extends State<MonthlyRevenueChart> {
  late List<SalesData> chartData;
  late dynamic data;

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  // @override
  // void initState() {
  //   super.initState();

  //   chartData = generateSalesData(selectedMonth, selectedYear);
  //   data = getStatisticalMonth(selectedYear, selectedMonth);
  //   print('month: $selectedMonth -  year: $selectedYear');
  // }

  @override
  void initState() {
    super.initState();
    _updateData(); // Call a method to initialize data
  }

  void _updateData() {
    setState(() {
      chartData = generateSalesData(selectedMonth, selectedYear);
      data = getStatisticalMonth(selectedYear, selectedMonth);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            List<StatisticalMonth> statisticalMonth =
                snapshot.data as List<StatisticalMonth>;
            chartData =
                statisticalMonth.map((e) => SalesData(e.day, e.total)).toList();
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //chọn năm
                          DropdownButton<int>(
                            value: selectedYear,
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                                _updateData();
                              });
                            },
                            items: List.generate(5, (index) {
                              return DropdownMenuItem<int>(
                                value: DateTime.now().year - index,
                                child: Text(
                                    (DateTime.now().year - index).toString()),
                              );
                            }),
                          ),
                
                          //lựa chọn tháng trong năm
                
                          DropdownButton<int>(
                            value: selectedMonth,
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value!;
                                _updateData();
                              });
                            },
                            items: List.generate(12, (index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text(monthNames[index]),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Biểu đồ doanh thu theo tháng:',
                      style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 30),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tháng ${selectedMonth} - Năm ${selectedYear}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <CartesianSeries>[
                                LineSeries<SalesData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (SalesData sales, _) =>
                                        'Ngày ${sales.day.toString()}',
                                    yValueMapper: (SalesData sales, _) =>
                                        sales.sales)
                              ]),
                        ],
                      ),
                    ),
                
                   const SizedBox(height: 20,)
                  ],
                ),
              ),
            );
          }
        });
  }

  List<SalesData> generateSalesData(int month, int year) {
    // Thêm giá trị doanh thu cho mỗi ngày trong tháng
    List<int> dailySales = [
      100,
      760,
      150,
      120,
      400,
      120,
      300,
      120,
      100,
      200,
      150,
      120,
      100,
      600,
      150,
      120,
      100,
      200,
      450,
      120,
      100,
      200,
      150,
      120,
      100,
      760,
      150,
      120,
      100,
      400,
      150,
      120,
    ];

    List<SalesData> data = [];
    int daysInMonth = DateTime(year, month + 1, 0).day; // Số ngày trong tháng

    for (int i = 1; i <= daysInMonth; i++) {
      data.add(SalesData(
          i,
          dailySales[
              i - 1])); // Sử dụng giá trị doanh thu tương ứng với mỗi ngày
    }

    return data;
  }
}

class SalesData {
  SalesData(this.day, this.sales);
  final int day;
  final int sales;
}

final List<String> monthNames = [
  'Tháng 1',
  'Tháng 2',
  'Tháng 3',
  'Tháng 4',
  'Tháng 5',
  'Tháng 6',
  'Tháng 7',
  'Tháng 8',
  'Tháng 9',
  'Tháng 10',
  'Tháng 11',
  'Tháng 12',
];

// void main() {
//   runApp(MaterialApp(
//     home: MonthlyRevenueChart(selectedMonth: 7, selectedYear: 2024),
//   ));
// }
