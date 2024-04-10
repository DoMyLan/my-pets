import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/chart_folder/monthly_revenue.dart';
import 'package:found_adoption_application/screens/chart_folder/yearly_revenue.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Revenue Chart Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: RevenueChartPage(),
//     );
//   }
// }

class RevenueChartPage extends StatefulWidget {
  const RevenueChartPage({super.key});

  @override
  State<RevenueChartPage> createState() => _RevenueChartPageState();
}

class _RevenueChartPageState extends State<RevenueChartPage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool showYearDropdownOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuFrameUser(
                      userId: currentClient.id,
                    ),
                  ),
                );
              } else if (currentClient.role == 'CENTER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MenuFrameCenter(centerId: currentClient.id),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
        title: const Text(
          'THỐNG KÊ DOANH THU',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: const [
          Icon(
            size: 40,
            Icons.show_chart, // Thay bằng icon mong muốn
            color: Color.fromRGBO(48, 96, 96, 1.0), // Thay bằng màu mong muốn
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (showYearDropdownOnly == true) {
                    selectedMonth = 1;
                    showYearDropdownOnly = false;
                  } else {
                    selectedMonth = 0;
                    showYearDropdownOnly = true;
                  }
                });
              },
              child: Text(
                showYearDropdownOnly
                    ? 'Thống kê doanh thu theo năm (Nhấn để thay đổi)'
                    : 'Thống kê doanh thu theo tháng (Nhấn để thay đổi)',
                style: const TextStyle(
                    fontSize: 13, color: Color.fromRGBO(48, 96, 96, 1.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                      });
                    },
                    items: List.generate(5, (index) {
                      return DropdownMenuItem<int>(
                        value: DateTime.now().year - index,
                        child: Text((DateTime.now().year - index).toString()),
                      );
                    }),
                  ),

                  //lựa chọn tháng trong năm
                  if (!showYearDropdownOnly)
                    DropdownButton<int>(
                      value: selectedMonth,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
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
            const SizedBox(height: 20),
            Expanded(
              child: selectedMonth == 0
                  ? YearlyRevenueChart(selectedYear: selectedYear)
                  : MonthlyRevenueChart(
                      selectedMonth: selectedMonth,
                      selectedYear: selectedYear,
                    ),
            ),
          ],
        ),
      ),
    );
  }
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
