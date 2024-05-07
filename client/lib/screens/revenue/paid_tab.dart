import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/item_paid.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/screens/chart_folder/chart_revenue_screen.dart';
import 'package:found_adoption_application/screens/revenue/revenue_detail_item.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:intl/intl.dart';

class PaidTab extends StatefulWidget {
  final String centerId;

  const PaidTab({super.key, required this.centerId});
  @override
  State<PaidTab> createState() => _PaidTabState();
}

class _PaidTabState extends State<PaidTab> {
  late DateTime start;
  late DateTime end;
  Future<List<Order>>? ordersFuture;
  late double total = 0;
  late String nameCenter = 'Trung tâm ABC';

  @override
  void initState() {
    super.initState();
    ordersFuture = getRevenue(widget.centerId, "PAID");

    start = DateTime.parse('2023-08-04');
    end = DateTime.parse('2023-08-16');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ordersFuture,
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

            List<Order> orders = snapshot.data as List<Order>;
            if(orders.isEmpty) {
              return const Center(
                child: Text('Không có dữ liệu'),
              );
            }
            total = orders.fold(0, (previousValue, element) => previousValue + element.totalPayment);
            nameCenter = orders[0].seller.centerId!.name;


            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$total VNĐ',
                    style: const TextStyle(
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.paw,
                        size: 20,
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                      ),
                      Text(
                        nameCenter,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const RevenueChartPage())));
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

                  const Text('Số tiền thanh toán (4 Th08 2023 - 16 Th08 2023)'),

                  //BẮT ĐẦU + KẾT THÚC
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(start),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Column(
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
                        SizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(end),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
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
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final item = orders[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RevenueDetailScreen(orderId: item.id,)));
                          },
                          child: ListItemWidget(
                            imageUrl: item.petId.images[0],
                            title: item.petId.namePet,
                            price: item.petId.price.toString(),
                            sellerName: item.seller.centerId!.name,
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
        });
  }
}
