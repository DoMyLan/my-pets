import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/screens/user_screens/feedback.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/fomatPrice.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:intl/intl.dart';

class TrackingOrder extends StatefulWidget {
  final String orderId;
  const TrackingOrder({super.key, required this.orderId});

  @override
  State<TrackingOrder> createState() => _TrackingOrderState();
}

class _TrackingOrderState extends State<TrackingOrder> {
  Future<Order>? orderFuture;

  @override
  void initState() {
    super.initState();

    orderFuture = getOrderDetailByBuyer(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromRGBO(48, 96, 96, 1.0),
              )),
          title: const Text(
            'Chi tiết đơn hàng',
            style: TextStyle(
                color: Color.fromRGBO(
                  48,
                  96,
                  96,
                  1.0,
                ),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const errorWidget();
            } else {
              Order order = snapshot.data as Order;

              return Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      petItem(order),
                      const SizedBox(
                        height: 10,
                      ),

                      //chi tiết đơn hàng
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.list_alt,
                              color: Color.fromARGB(255, 209, 191, 28),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Chi tiết thanh toán',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Mã đơn hàng',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  Text(
                                    order.id.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Giá sản phẩm',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  Text(
                                    '${formatPrice(order.price)} đ',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              order.voucherProduct != 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Giảm giá sản phẩm',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Text(
                                          '-${formatPrice(order.voucherProduct)} đ',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Phí vận chuyển',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  Text(
                                    '${formatPrice(order.transportFee)} đ',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              order.voucherShipping != 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Giảm giá vận chuyển',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Text(
                                          '-${formatPrice(order.voucherProduct)} đ',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tổng đơn hàng',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  Text(
                                    '${formatPrice(order.totalFee)} đ',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              order.voucherTotal != 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Giảm giá đơn hàng',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Text(
                                          '-${formatPrice(order.voucherTotal)} đ',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Thành tiền',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    '${formatPrice(order.totalPayment)} đ',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                height: 1,
                                indent: 0,
                                endIndent: 0,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Phương thức thanh toán",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    order.paymentMethods == "COD"
                                        ? "Thanh toán khi nhận hàng"
                                        : "VNPAY",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blue),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Trạng thái thanh toán",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    order.statusPayment == "PENDING"
                                        ? "Chờ thanh toán"
                                        : "Đã thanh toán",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: order.statusPayment == "PENDING"
                                            ? Colors.orange
                                            : Colors.green),
                                  )
                                ],
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 1,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Color.fromRGBO(48, 96, 96, 1.0),
                                ),
                                Text(
                                  "Địa chỉ nhận hàng",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(48, 96, 96, 1.0)),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${order.buyer.firstName} ${order.buyer.lastName}",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    order.buyer.phoneNumber,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    order.buyer.address,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 1,
                              indent: 90,
                              endIndent: 90,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      //Progress Delivery
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TrackingStep(
                            date: order.createdAt,
                            icon: FontAwesomeIcons.cartShopping,
                            title: 'Ngày đặt hàng',
                            isFirstStep: true,
                            isCurrentStep: true,
                            isLastStep: false,
                          ),
                          TrackingStep(
                            date: order.dateConfirm,
                            icon: Icons.home,
                            title: 'Ngày xác nhận đơn hàng',
                            isFirstStep: false,
                            isCurrentStep:
                                order.dateConfirm != null ? true : false,
                            isLastStep: false,
                          ),
                          TrackingStep(
                            date: order.dateDelivering,
                            icon: Icons.delivery_dining,
                            title: 'Ngày chuyển hàng',
                            isFirstStep: false,
                            isCurrentStep:
                                order.dateDelivering != null ? true : false,
                            isLastStep: false,
                          ),
                          TrackingStep(
                            date: order.dateCompleted,
                            icon: Icons.done,
                            title: 'Ngày hoàn thành đơn hàng',
                            isFirstStep: false,
                            isCurrentStep:
                                order.dateCompleted != null ? true : false,
                            isLastStep: true,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ]);
            }
          },
        ),
        bottomNavigationBar: FutureBuilder(
            future: orderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const errorWidget();
              } else {
                Order order = snapshot.data as Order;

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      order.statusPayment == "PENDING" &&
                              order.paymentMethods == "ONLINE" &&
                              order.statusOrder != "CANCEL"
                          ? GestureDetector(
                              onTap: () async {},
                              child: Container(
                                width: 130,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Thanh toán VNPAY',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const Spacer(),
                      order.statusOrder == "PENDING"
                          ? Positioned(
                              left: 105,
                              bottom: 30,
                              child: GestureDetector(
                                onTap: () async {
                                  Loading(context);
                                  await changeStatusOrder(order.id, 'CANCEL');
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.orange,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Hủy đơn hàng",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      order.statusOrder == "COMPLETED" && order.rating == false
                          ? Positioned(
                              left: 105,
                              bottom: 30,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddFeedBackScreen(
                                        order: order,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.orange,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Đánh giá",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              }
            }));
  }

  Widget petItem(Order order) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 248, 245, 245),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
                // Placeholder for pet image
                child: Image.network(
                  order.petId.images[0].toString(),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.petId.namePet.toString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Loại thú cưng: ${order.petId.petType}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Ngày đặt hàng: ${order.createdAt.toString().substring(0, 10)}',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                order.seller.typeSeller == 'C'
                    ? order.seller.centerId!.name
                    : '${order.seller.userId!.firstName} ${order.seller.userId!.lastName}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final DateTime? date;
  final IconData icon;
  final String title;
  final bool isFirstStep;
  final bool isCurrentStep;
  final bool isLastStep;

  const TrackingStep({
    super.key,
    required this.date,
    required this.icon,
    required this.title,
    required this.isFirstStep,
    required this.isCurrentStep,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width * 0.25;
    return Padding(
      padding: EdgeInsets.only(left: widthDevice),
      child: Column(
        children: [
          if (!isFirstStep)
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 2.0,
                  height: 25.0,
                  color: isCurrentStep ? Colors.black : Colors.grey[400],
                ),
              ],
            ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isCurrentStep ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: isCurrentStep ? Colors.blue : Colors.grey.shade400,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isCurrentStep ? Colors.white : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isCurrentStep ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  date != null
                      ? Text(DateFormat('EEEE, d/M/y | HH:mm')
                          .format(date!)
                          .toString())
                      : const Text("Chờ cập nhật")
                ],
              ),
            ],
          ),
          if (!isLastStep)
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 2.0,
                  height: 25.0,
                  color: isCurrentStep ? Colors.black : Colors.grey[400],
                ),
              ],
            ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PaymentScreen(),
//     );
//   }
// }

// class PaymentScreen extends StatefulWidget {
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text('Thanh toán'),
//       ),
//       body: SafeArea(
//         child: Stack(children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               color: Colors.red,
//                             ),
//                             SizedBox(width: 5),
//                             Text(
//                               'Địa chỉ nhận hàng',
//                               style: TextStyle(
//                                 fontSize: 13.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 28.0),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width *
//                                 0.7, // Chiều rộng tối đa
//                             child: Text(
//                               '143/11 đường số 11, khu phố 9, phường Trường Thọ, Tp. Thủ Đức, Tp. Hồ Chí Minh',
//                               style: TextStyle(
//                                 fontSize: 13.0,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               softWrap: true,
//                               maxLines: null,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal:
//                             0), // Điều chỉnh lề bên trái và bên phải của Divider
//                     child: Divider(
//                       color: Theme.of(context).primaryColor,
//                       thickness: 5,
//                       height: 30,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         'Trung tâm thú cưng Miami',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 12,
//                     ),
//                     Text('View Center'),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       size: 12,
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(4),
//                   color: Color.fromARGB(255, 248, 245, 245),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 100.0,
//                         height: 100.0,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.0),
//                           color: Colors.grey[300],
//                         ),
//                         // Placeholder for pet image
//                         child: Image.asset('assets/images/Lan.jpg'),
//                       ),
//                       SizedBox(width: 20.0),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Sữa VinaMilk',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Text(
//                             'Breed: Mèo Anh lông ngắn',
//                             style: TextStyle(fontSize: 14.0),
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Text(
//                             'Price: 235000 đ',
//                             style: TextStyle(fontSize: 14.0),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Divider(
//                   color: Colors.grey.shade300,
//                   thickness: 1,
//                   height: 1,
//                 ),
//                 SizedBox(height: 15.0),
//                 Row(
//                   children: [
//                     Icon(Icons.wallet_giftcard,
//                         color: Color.fromARGB(255, 209, 191, 28)),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       'Voucher của Center',
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Nhập mã voucher',
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.0),
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
//                       ),
//                       onPressed: () {},
//                       child: Text('Áp dụng', style: TextStyle(fontSize: 13, color: Colors.white),),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Tin nhắn: ',
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 100,
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                             hintText: 'Lưu ý cho Trung tâm...',
//                             border: InputBorder.none,
//                             hintStyle: TextStyle(
//                                 fontSize: 15, color: Colors.grey.shade400)),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Divider(
//                   color: Colors.grey.shade300,
//                   thickness: 10,
//                   height: 1,
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.monetization_on_outlined,
//                       color: Colors.red,
//                     ),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       'Phương thức thanh toán (Nhấn để chọn)',
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         color: Color.fromARGB(255, 99, 182, 124),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Divider(
//                   color: Colors.grey.shade300,
//                   thickness: 1,
//                   height: 1,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.list_alt,
//                       color: Color.fromARGB(255, 209, 191, 28),
//                     ),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       'Chi tiết thanh toán',
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Tổng tiền hàng',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13.0,
//                         ),
//                       ),
//                       Text(
//                         '235000 đ',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Tổng tiền phí vận chuyển',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13.0,
//                         ),
//                       ),
//                       Text(
//                         '40000 đ',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 13.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Tổng tiền hàng',
//                         style: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                       ),
//                       Text(
//                         '275000 đ',
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 13.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Divider(
//                 //   color: Colors.grey.shade300,
//                 //   thickness: 1,
//                 //   height: 1,
//                 // ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade100,
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0,
//                         3), // Thay đổi offset để điều chỉnh vị trí của bóng đổ
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         'Tổng thanh toán',
//                         style: TextStyle(
//                           fontSize: 13.0,
//                         ),
//                       ),
//                       Text(
//                         '275000 đ',
//                         style: TextStyle(
//                           fontSize: 15.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 20),
//                   GestureDetector(
//                     onTap: () {
//                       // Xử lý sự kiện khi nhấn vào nút Đặt hàng
//                     },
//                     child: Container(
//                       color: Colors.red,
//                       height: 50,
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Center(
//                         child: TextButton(
//                           child: Text(
//                             'Đặt hàng',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           onPressed: () {},
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }