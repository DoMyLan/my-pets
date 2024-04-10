import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/statistical.dart';
import 'package:found_adoption_application/services/order/statisticalApi.dart';
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
  late dynamic data;

  @override
  void initState() {
    super.initState();
    chartData = generateSalesData(widget.selectedMonth, widget.selectedYear);
    data = getStatisticalMonth(widget.selectedYear, widget.selectedMonth);
  
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
          List<StatisticalMonth> statisticalMonth = snapshot.data as List<StatisticalMonth>;
          chartData = statisticalMonth
              .map((e) => SalesData(e.day, e.total))
              .toList();
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
                              xValueMapper: (SalesData sales, _) => 'Ngày ${sales.day.toString()}',
                              yValueMapper: (SalesData sales, _) => sales.sales)
                        ]),
                  ],
                ),
              ),
            ],
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

// void main() {
//   runApp(MaterialApp(
//     home: MonthlyRevenueChart(selectedMonth: 7, selectedYear: 2024),
//   ));
// }
