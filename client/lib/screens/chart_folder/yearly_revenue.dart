import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyRevenueChart extends StatefulWidget {
  final int selectedYear;
  YearlyRevenueChart({required this.selectedYear});

  @override
  State<YearlyRevenueChart> createState() => _YearlyRevenueChartState();
}

class _YearlyRevenueChartState extends State<YearlyRevenueChart> {
  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData('Jan', 10),
      SalesData('Feb', 18),
      SalesData('Mar', 14),
      SalesData('Apr', 24),
      SalesData('May', 20),
      SalesData('Jun', 20),
      SalesData('Jul', 20),
      SalesData('Aug', 38),
      SalesData('Sep', 30),
      SalesData('Oct', 32),
      SalesData('Nov', 20),
      SalesData('Dec', 30),
    ];

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                  const SizedBox(
                    height: 15,
                  ),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(), // Changed to CategoryAxis
                      series: <CartesianSeries>[
                        // Renders line chart
                        LineSeries<SalesData, String>(
                            // Changed the generic type to String
                            dataSource: chartData,
                            xValueMapper: (SalesData sales, _) =>
                                sales.year, // Now returns a String
                            yValueMapper: (SalesData sales, _) => sales.sales)
                      ]),
                ],
              )),
        ],
      ),
    ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

// void main() {
//   runApp(MaterialApp(
//     home: YearlyRevenueChart(selectedYear: 2024),
//   ));
// }
