import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/order/statisticalApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyRevenueChart extends StatefulWidget {
  final int selectedYear;
  YearlyRevenueChart({required this.selectedYear});

  @override
  State<YearlyRevenueChart> createState() => _YearlyRevenueChartState();
}

class _YearlyRevenueChartState extends State<YearlyRevenueChart> {
  late dynamic data;
  @override
  void initState() {
    super.initState();
    data = getStatisticalYear(widget.selectedYear.toString());
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

            List<StatisticalYear> statisticalYear = snapshot.data as List<StatisticalYear>;
            chartData = statisticalYear
                .map((e) => SalesData(e.month, e.total))
                .toList();

            return Scaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biểu đồ doanh thu theo năm',
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Năm ${widget.selectedYear}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SfCartesianChart(
                              primaryXAxis:
                                  const CategoryAxis(), // Changed to CategoryAxis
                              series: <CartesianSeries>[
                                // Renders line chart
                                LineSeries<SalesData, String>(
                                    // Changed the generic type to String
                                    dataSource: chartData,
                                    xValueMapper: (SalesData sales, _) =>
                                        sales.month.toString(), // Now returns a String
                                    yValueMapper: (SalesData sales, _) =>
                                        sales.sales)
                              ]),
                        ],
                      )),
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
