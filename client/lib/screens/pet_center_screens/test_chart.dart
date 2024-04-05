// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class RevenueChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 2000,
//           barTouchData: BarTouchData(enabled: false),
//           titlesData: FlTitlesData(
//               show: true,
//               bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 30,
//                 getTitlesWidget: (value, meta) {
//                   switch (value.toInt()) {
//                     case 0:
//                       return Text('Jan');
//                     case 1:
//                       return Text('Feb');
//                     case 2:
//                       return Text('Mar');
//                     case 3:
//                       return Text('Apr');
//                     case 4:
//                       return Text('May');
//                     case 5:
//                       return Text('Jun');
//                     case 6:
//                       return Text('Jul');
//                     case 7:
//                       return Text('Aug');
//                     case 8:
//                       return Text('Sep');
//                     case 9:
//                       return Text('Oct');
//                     case 10:
//                       return Text('Nov');
//                     case 11:
//                       return Text('Dec');
//                     default:
//                       return Text('');
//                   }
//                 },
//               )),
//               leftTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false))),
//           borderData: FlBorderData(
//             show: false,
//           ),
//           barGroups: [
//             BarChartGroupData(
//               x: 0,
//               barRods: [
//                 BarChartRodData(toY: 1500, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 1,
//               barRods: [
//                 BarChartRodData(toY: 1800, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 2,
//               barRods: [
//                 BarChartRodData(toY: 1200, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 3,
//               barRods: [
//                 BarChartRodData(toY: 1700, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 4,
//               barRods: [
//                 BarChartRodData(toY: 2000, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 5,
//               barRods: [
//                 BarChartRodData(toY: 1600, color:Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 6,
//               barRods: [
//                 BarChartRodData(toY: 1900, color:Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 7,
//               barRods: [
//                 BarChartRodData(toY: 1400, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 8,
//               barRods: [
//                 BarChartRodData(toY: 1750, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 9,
//               barRods: [
//                 BarChartRodData(toY: 1850, color: Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 10,
//               barRods: [
//                 BarChartRodData(toY: 1300, color:Colors.blue),
//               ],
//             ),
//             BarChartGroupData(
//               x: 11,
//               barRods: [
//                 BarChartRodData(toY: 1950, color: Colors.blue),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Revenue Chart'),
//       ),
//       body: RevenueChart(),
//     ),
//   ));
// }



// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class MonthlyRevenueChart extends StatelessWidget {
//   // Dữ liệu doanh thu trong vòng 1 tháng
//   final List<double> dailyRevenue = [
//     150.0,
//     180.0,
//     120.0,
//     170.0,
//     200.0,
//     160.0,
//     190.0,
//     140.0,
//     175.0,
//     185.0,
//     130.0,
//     195.0,
//     220.0,
//     230.0,
//     250.0,
//     210.0,
//     240.0,
//     270.0,
//     200.0,
//     230.0,
//     240.0,
//     210.0,
//     220.0,
//     210.0,
//     260.0,
//     250.0,
//     280.0,
//     270.0,
//     290.0,
//     310.0,
//     300.0,
//     320.0
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: LineChart(
//         LineChartData(
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(
//                 dailyRevenue.length,
//                 (index) => FlSpot(index.toDouble(), dailyRevenue[index]),
//               ),
//               isCurved: true,
//               color: Colors.blue,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//           titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     if (value % 50 == 0) {
//                       return Text(value.toString());
//                     }
//                     return Text('');
//                   },
//                 ),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     if (value % 5 == 0) {
//                       return Text(value.toInt().toString());
//                     }
//                     return Text('');
//                   },
//                 ),
//               )),
//           borderData: FlBorderData(show: true),
//           minX: 0,
//           maxX: 31,
//           minY: 0,
//           maxY: dailyRevenue.reduce(
//                   (value, element) => value > element ? value : element) +
//               50, // Tính toán giá trị lớn nhất và thêm 50 cho biên dưới của biểu đồ
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Monthly Revenue Chart'),
//       ),
//       body: MonthlyRevenueChart(),
//     ),
//   ));
// }



