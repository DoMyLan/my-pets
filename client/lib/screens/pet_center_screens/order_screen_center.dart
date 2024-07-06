import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/order_state_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/fomatPrice.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/non_order.dart';
import 'package:intl/intl.dart';

class TheOrdersCenter extends StatefulWidget {
  const TheOrdersCenter({super.key});

  @override
  State<TheOrdersCenter> createState() => _TheOrdersCenterState();
}

class _TheOrdersCenterState extends State<TheOrdersCenter>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.bars,
                size: 25, color: Color.fromRGBO(48, 96, 96, 1.0)),
            onPressed: () async {
              var currentClient = await getCurrentClient();

              if (currentClient != null) {
                if (currentClient.role == 'USER') {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
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
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MenuFrameCenter(centerId: currentClient.id),
                    ),
                  );
                }
              }
            },
          ),
          title: const Text(
            'Quản lý đơn hàng',
            style: TextStyle(
                color: Color.fromRGBO(48, 96, 96, 1.0),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.only(left: 0, right: 14),
              labelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              controller: _tabController,
              labelColor: Colors.black,
              indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      width: 2, style: BorderStyle.solid, color: Colors.black),
                  insets: EdgeInsets.zero),
              unselectedLabelColor: Colors.grey,
              tabs: const <Widget>[
                Tab(text: 'Chờ xác nhận'),
                Tab(text: 'Đã xác nhận'),
                Tab(text: 'Đang vận chuyển'),
                Tab(text: 'Giao thành công'),
                Tab(text: 'Bị hủy'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabTrackingOrder(status: 'PENDING', tabIndex: 0),
                  TabTrackingOrder(status: 'CONFIRMED', tabIndex: 1),
                  TabTrackingOrder(status: 'DELIVERING', tabIndex: 2),
                  TabTrackingOrder(status: 'COMPLETED', tabIndex: 3),
                  TabTrackingOrder(status: 'CANCEL', tabIndex: 4),
                ],
              ),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class TabTrackingOrder extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var status;
  final int tabIndex;
  TabTrackingOrder({
    super.key,
    required this.status,
    required this.tabIndex,
  });

  @override
  State<TabTrackingOrder> createState() => _TabTrackingOrderState();
}

class _TabTrackingOrderState extends State<TabTrackingOrder> {
  Future<List<Order>>? orderFuture;
  late List<Order> orders;
  List<Order> previousOrders = [];

  final List<String> statusOrder = [
    'PENDING',
    'CONFIRMED',
    'DELIVERING',
    'DELIVERED',
    'CANCEL',
  ];
  final List<String> statusOrderText = [
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang vận chuyển',
    'Giao hàng',
    'Bị hủy'
  ];
  final List<String> statusOrderButton = [
    'Xác nhận',
    'Vận chuyển',
    'Giao hàng',
    '',
    ''
  ];

  @override
  void initState() {
    super.initState();
    orderFuture = getOrdersBySeller(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const errorWidget();
          } else {
            orders = snapshot.data as List<Order>;
            if (widget.status == 'PENDING') {
              orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            } else if (widget.status == 'CONFIRMED') {
              orders.sort((a, b) => b.dateConfirm!.compareTo(a.dateConfirm!));
            } else if (widget.status == 'DELIVERING') {
              orders.sort(
                  (a, b) => b.dateDelivering!.compareTo(a.dateDelivering!));
            } else if (widget.status == 'COMPLETED') {
              orders.sort((a, b) {
                // Use dateCompleted if it's not null, otherwise fall back to dateDelivering.
                var dateA = a.dateCompleted ?? a.dateDelivering;
                var dateB = b.dateCompleted ?? b.dateDelivering;
                return dateB!.compareTo(dateA!); // Swapped dateB and dateA here
              });
            } else if (widget.status == 'CANCEL') {
              orders.sort((a, b) => b.dateCancel!.compareTo(a.dateCancel!));
            }
            if (orders.isEmpty) {
              return const NonOrderWidget();
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      String orderDate = DateFormat('dd/MM/yyyy')
                          .format(widget.status == 'PENDING'
                              ? orders[index].createdAt
                              : widget.status == 'CONFIRMED'
                                  ? orders[index].dateConfirm!
                                  : widget.status == 'DELIVERING'
                                      ? orders[index].dateDelivering!
                                      : widget.status == 'COMPLETED'
                                          ? orders[index].dateCompleted != null
                                              ? orders[index].dateCompleted!
                                              : orders[index].dateDelivering!
                                          : orders[index].dateCancel!);
                      bool isToday = orderDate ==
                          DateFormat('dd/MM/yyyy').format(DateTime.now());
                      bool showDateHeader = index == 0 ||
                          orderDate !=
                              DateFormat('dd/MM/yyyy').format(widget.status ==
                                      'PENDING'
                                  ? orders[index - 1].createdAt
                                  : widget.status == 'CONFIRMED'
                                      ? orders[index - 1].dateConfirm!
                                      : widget.status == 'DELIVERING'
                                          ? orders[index - 1].dateDelivering!
                                          : widget.status == 'COMPLETED'
                                              ? orders[index].dateCompleted !=
                                                      null
                                                  ? orders[index - 1]
                                                              .dateCompleted !=
                                                          null
                                                      ? orders[index - 1]
                                                          .dateCompleted!
                                                      : orders[index - 1]
                                                          .dateDelivering!
                                                  : orders[index - 1]
                                                      .dateDelivering!
                                              : orders[index - 1].dateCancel!);

                      return Column(
                        children: [
                          if (showDateHeader)
                            Column(
                              children: [
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(child: Divider()),
                                      Text(
                                        isToday ? 'Hôm nay' : 'Ngày $orderDate',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      TrackingOrderCenter(
                                    orderId: orders[index].id,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = const Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var tween = Tween(begin: begin, end: end);
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 0),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                width: 70,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.orange,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Following",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                orders[index].seller.centerId !=
                                                        null
                                                    ? orders[index]
                                                        .seller
                                                        .centerId!
                                                        .name
                                                    : orders[index]
                                                        .seller
                                                        .userId!
                                                        .lastName,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              orders[index].statusPayment ==
                                                      'PENDING'
                                                  ? 'Chờ thanh toán'
                                                  : 'Đã thanh toán',
                                              style: TextStyle(
                                                  color: orders[index]
                                                              .statusPayment ==
                                                          'PENDING'
                                                      ? Colors.orange
                                                      : Colors.green),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: Image.network(
                                                orders[index].petId.images[0]!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    orders[index].petId.namePet,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Loài: ${orders[index].petId.petType}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Giá: ${formatPrice(orders[index].price)}đ",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 10,
                                          thickness: 1,
                                          indent: 0,
                                          endIndent: 0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Tổng: ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${formatPrice(orders[index].totalFee)}đ",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            const Spacer(),
                                            (widget.tabIndex == 0 &&
                                                        orders[index]
                                                                .statusPayment ==
                                                            "PENDING" &&
                                                        orders[index]
                                                                .paymentMethods ==
                                                            "ONLINE") ||
                                                    (widget.tabIndex == 0 &&
                                                        orders[index]
                                                                .paymentMethods ==
                                                            "COD")
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      Loading(context);
                                                      //Hủy đơn hàng
                                                      await changeStatusOrder(
                                                          orders[index].id,
                                                          "CANCEL");
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        orders.removeAt(index);
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 60,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.red[400],
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "Hủy",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            widget.tabIndex == 2 &&
                                                    orders[index]
                                                            .paymentMethods ==
                                                        'COD' &&
                                                    orders[index]
                                                            .statusPayment ==
                                                        "PENDING"
                                                ? Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Loading(context);
                                                          //Xác nhận thanh toán COD
                                                          await confirmPayment(
                                                              orders[index].id);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            orders[index]
                                                                    .statusPayment =
                                                                "PAID";
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 120,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.blue,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Thanh toán COD',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      //refund
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Loading(context);
                                                          //Hủy đơn hàng
                                                          await changeStatusOrder(
                                                              orders[index].id,
                                                              "CANCEL");
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            orders.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 85,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Hủy đơn',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : widget.tabIndex == 2 &&
                                                        orders[index]
                                                                .paymentMethods ==
                                                            'COD' &&
                                                        orders[index]
                                                                .statusPayment ==
                                                            "PAID"
                                                    ? GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                          width: 120,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Đã thanh toán',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                            widget.tabIndex < 3 &&
                                                    ((orders[index].statusPayment ==
                                                                'PAID' &&
                                                            orders[index]
                                                                    .paymentMethods ==
                                                                'COD') ||
                                                        orders[index]
                                                                .paymentMethods ==
                                                            'ONLINE')
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      Loading(context);
                                                      await changeStatusOrder(
                                                          orders[index].id,
                                                          statusOrder[
                                                              widget.tabIndex +
                                                                  1]);
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);

                                                      setState(() {
                                                        orders.removeAt(index);
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 85,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.orange,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          statusOrderButton[
                                                              widget.tabIndex],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
          }
        });
  }
}
