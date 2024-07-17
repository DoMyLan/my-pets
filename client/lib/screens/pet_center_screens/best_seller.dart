import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BestSellingPetsScreen2 extends StatelessWidget {
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 8, color: Colors.lightBlue)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 10, color: Colors.lightGreen)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 14, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),
    BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 1000, color: Colors.pinkAccent)],
        showingTooltipIndicators: [0]),

    // Thêm dữ liệu cho các thú cưng khác tại đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Biểu Đồ Thú Cưng Bán Chạy')),
      body: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Cho phép lướt ngang
          child: Container(
            width:
                800, // Đặt chiều rộng cố định cho biểu đồ, điều chỉnh theo nhu cầu
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Tên thú cưng',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    sideTitles: SideTitles(showTitles: false),
                    drawBelowEverything: bool.fromEnvironment('true'),
                    
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
