import 'dart:math';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/order/statisticalApi.dart';
import 'package:intl/intl.dart';
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Tổng doanh thu',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        child: Text(
                                          monthNames[index],
                                          style: const TextStyle(fontSize: 16),
                                        ));
                                  }),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'năm ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
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
                                      (DateTime.now().year - index).toString(),
                                      style: const TextStyle(fontSize: 16)),
                                );
                              }),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng: ${NumberFormat('#,##0', 'vi_VN').format(statisticalMonth.fold<int>(0, (previousValue, element) => previousValue + element.total))} VND',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  'Đã thanh toán: ${NumberFormat('#,##0', 'vi_VN').format(statisticalMonth.fold<int>(0, (previousValue, element) => previousValue + element.paid))} VND',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  'Chưa thanh toán: ${NumberFormat('#,##0', 'vi_VN').format(statisticalMonth.fold<int>(0, (previousValue, element) => previousValue + element.pending))} VND',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Cao nhất tháng (Ngày ${statisticalMonth.reduce((currentMax, e) => e.total > currentMax.total ? e : currentMax).day}): ${NumberFormat('#,##0', 'vi_VN').format(statisticalMonth.map((e) => e.total).reduce(max))} VND',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Trung bình tháng: ${NumberFormat('#,##0', 'vi_VN').format(statisticalMonth.fold<int>(0, (previousValue, element) => previousValue + element.total) / statisticalMonth.length)} VND',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Biểu đồ doanh thu tháng $selectedMonth năm $selectedYear:',
                      style: const TextStyle(
                          fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 30),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SfCartesianChart(
                              primaryXAxis: const CategoryAxis(),
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
                    const SizedBox(
                      height: 20,
                    )
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
