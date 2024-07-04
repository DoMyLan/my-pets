import 'dart:math';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/order/statisticalApi.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyRevenueChart extends StatefulWidget {
  @override
  State<YearlyRevenueChart> createState() => _YearlyRevenueChartState();
}

class _YearlyRevenueChartState extends State<YearlyRevenueChart> {
  late dynamic data;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _updateData(); // Call a method to initialize data
  }

  void _updateData() {
    setState(() {
      data = getStatisticalYear(selectedYear.toString());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    late List<SalesData> chartData = [
      SalesData(1, 10),
      SalesData(2, 18),
      SalesData(3, 14),
      SalesData(4, 24),
      SalesData(5, 20),
      SalesData(6, 20),
      SalesData(7, 20),
      SalesData(8, 38),
      SalesData(9, 30),
      SalesData(10, 32),
      SalesData(11, 20),
      SalesData(12, 30),
    ];

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
            List<StatisticalYear> statisticalYear =
                snapshot.data as List<StatisticalYear>;
            chartData = statisticalYear
                .map((e) => SalesData(e.month, e.total))
                .toList();

            return Scaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              'Tổng doanh thu năm ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    child: Text((DateTime.now().year - index)
                                        .toString()),
                                  );
                                }),
                              ),
                            ],
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
                                'Tổng: ${NumberFormat('#,##0', 'vi_VN').format(statisticalYear.fold<int>(0, (previousValue, element) => previousValue + element.total))} VND',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.normal),
                              ),
                              Text(
                                'Đã thanh toán: ${NumberFormat('#,##0', 'vi_VN').format(statisticalYear.fold<int>(0, (previousValue, element) => previousValue + element.paid))} VND',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.normal),
                              ),
                              Text(
                                'Chưa thanh toán: ${NumberFormat('#,##0', 'vi_VN').format(statisticalYear.fold<int>(0, (previousValue, element) => previousValue + element.pending))} VND',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.normal),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Cao nhất năm (Tháng ${statisticalYear.reduce((currentMax, e) => e.total > currentMax.total ? e : currentMax).month}): ${NumberFormat('#,##0', 'vi_VN').format(statisticalYear.map((e) => e.total).reduce(max))} VND',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.normal),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Trung bình năm: ${NumberFormat('#,##0', 'vi_VN').format(statisticalYear.fold<int>(0, (previousValue, element) => previousValue + element.total) / statisticalYear.length)} VND',
                                style: const TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Biểu đồ doanh thu theo năm $selectedYear:',
                    style: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 30),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SfCartesianChart(
                              primaryXAxis:
                                  const CategoryAxis(), // Changed to CategoryAxis
                              series: <CartesianSeries>[
                                // Renders line chart
                                LineSeries<SalesData, String>(
                                    // Changed the generic type to String
                                    dataSource: chartData,
                                    xValueMapper: (SalesData sales, _) => sales
                                        .month
                                        .toString(), // Now returns a String
                                    yValueMapper: (SalesData sales, _) =>
                                        sales.sales)
                              ]),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ));
          }
        });
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final int month;
  final int sales;
}

// void main() {
//   runApp(MaterialApp(
//     home: YearlyRevenueChart(selectedYear: 2024),
//   ));
// }
