import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/item_paid.dart';
import 'package:found_adoption_application/screens/chart_folder/chart_revenue_screen.dart';
import 'package:found_adoption_application/screens/revenue/revenue_detail_item.dart';
import 'package:intl/intl.dart';

class PaidTab extends StatefulWidget {
  @override
  State<PaidTab> createState() => _PaidTabState();
}

class _PaidTabState extends State<PaidTab> {
  late DateTime start;
  late DateTime end;
  List<ListItemWidget> items = [];

  @override
  void initState() {
    super.initState();

    start = DateTime.parse('2023-08-04');
    end = DateTime.parse('2023-08-16');

    items = [
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Poodle - Bánh mỳ',
          price: '234.500',
          sellerName: 'Đặng Văn Tuấn'),
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Husky - Mít',
          price: '453.000',
          sellerName: 'Đỗ Thị Mỹ Lan'),
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Husky - Mít',
          price: '453.000',
          sellerName: 'Đỗ Thị Mỹ Lan'),
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Husky - Mít',
          price: '453.000',
          sellerName: 'Đỗ Thị Mỹ Lan'),
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Husky - Mít',
          price: '453.000',
          sellerName: 'Đỗ Thị Mỹ Lan'),
      ListItemWidget(
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/99/00/79/360_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg',
          title: 'Husky - Mít',
          price: '453.000',
          sellerName: 'Đỗ Thị Mỹ Lan'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '2.264.986',
            style: TextStyle(
                color: Color.fromRGBO(48, 96, 96, 1.0),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.paw,
                size: 20,
                color: Color.fromRGBO(48, 96, 96, 1.0),
              ),
              Text(
                'Trung Tâm Miami',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => RevenueChartPage())));
                },
                child: Text(
                  '(Biểu đồ doanh thu)',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),

          Text('Số tiền thanh toán (4 Th08 2023 - 16 Th08 2023)'),

          //BẮT ĐẦU + KẾT THÚC
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  child: InkWell(
                    onTap: () async {
                      // final pickedDate =
                      //     await _selectDate(context, start);
                      // if (pickedDate != null && mounted) {
                      //   setState(() {
                      //     start = pickedDate;
                      //   });
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MM-yyyy').format(start),
                            style: const TextStyle(
                                fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.minimize,
                      size: 40,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                Container(
                  width: 120,
                  height: 40,
                  child: InkWell(
                    onTap: () async {
                      // final pickedDate = await _selectDate(context, end);
                      // if (pickedDate != null && mounted) {
                      //   setState(() {
                      //     end = pickedDate;
                      //   });
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MM-yyyy').format(end),
                            style: const TextStyle(
                                fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.grey.shade200,
            thickness: 1,
            height: 13,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RevenueDetailScreen()));
                  },
                  child: ListItemWidget(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    price: item.price,
                    sellerName: item.sellerName,
                    // transactionDate: item.transactionDate,
                    // transactionStatus: item.transactionStatus,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
