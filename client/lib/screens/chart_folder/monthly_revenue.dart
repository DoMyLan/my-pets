import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyRevenueChart extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;
  MonthlyRevenueChart(
      {required this.selectedMonth, required this.selectedYear});

  @override
  State<MonthlyRevenueChart> createState() => _MonthlyRevenueChartState();
}

class _MonthlyRevenueChartState extends State<MonthlyRevenueChart> {
  late List<SalesData> chartData;

  @override
  void initState() {
    super.initState();
    chartData = generateSalesData(widget.selectedMonth, widget.selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biểu đồ doanh thu theo tháng:',
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
                  'Tháng ${widget.selectedMonth} - Năm ${widget.selectedYear}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      LineSeries<SalesData, String>(
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) => sales.day,
                          yValueMapper: (SalesData sales, _) => sales.sales)
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<SalesData> generateSalesData(int month, int year) {
    // Thêm giá trị doanh thu cho mỗi ngày trong tháng
    List<double> dailySales = [
      100.0,
      760.0,
      150.0,
      120.0,
      400.0,
      120.0,
      300.0,
      120.0,
      100.0,
      200.0,
      150.0,
      120.0,
      100.0,
      600.0,
      150.0,
      120.0,
      100.0,
      200.0,
      450.0,
      120.0,
      100.0,
      200.0,
      150.0,
      120.0,
      100.0,
      760.0,
      150.0,
      120.0,
      100.0,
      400.0,
      150.0,
      120.0,
    ];

    List<SalesData> data = [];
    int daysInMonth = DateTime(year, month + 1, 0).day; // Số ngày trong tháng

    for (int i = 1; i <= daysInMonth; i++) {
      data.add(SalesData(
          'Ngày $i',
          dailySales[
              i - 1])); // Sử dụng giá trị doanh thu tương ứng với mỗi ngày
    }

    return data;
  }
}

class SalesData {
  SalesData(this.day, this.sales);
  final String day;
  final double sales;
}

// void main() {
//   runApp(MaterialApp(
//     home: MonthlyRevenueChart(selectedMonth: 7, selectedYear: 2024),
//   ));
// }
