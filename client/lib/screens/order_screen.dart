import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/screens/order_state.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/feedback.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/fomatPrice.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/non_order.dart';

class TheOrders extends StatefulWidget {
  const TheOrders({super.key});

  @override
  State<TheOrders> createState() => _TheOrdersState();
}

class _TheOrdersState extends State<TheOrders>
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
            'Orders',
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
                Tab(text: 'Giao hàng'),
                Tab(text: 'Bị hủy'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabTrackingOrder(status: 'PENDING'),
                  TabTrackingOrder(status: 'CONFIRMED'),
                  TabTrackingOrder(status: 'DELIVERING'),
                  TabTrackingOrder(status: 'COMPLETED'),
                  TabTrackingOrder(status: 'CANCEL'),
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
  TabTrackingOrder({
    super.key,
    required this.status,
  });

  @override
  State<TabTrackingOrder> createState() => _TabTrackingOrderState();
}

class _TabTrackingOrderState extends State<TabTrackingOrder> {
  Future<List<Order>>? orderFuture;
  late List<Order> orders;
  @override
  void initState() {
    super.initState();
    orderFuture = getOrdersByBuyer(widget.status);
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
            if (orders.isEmpty) {
              return const NonOrderWidget();
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      TrackingOrder(
                                orderId: orders[index].id,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var tween = Tween(begin: begin, end: end);
                                var offsetAnimation = animation.drive(tween);

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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 0),
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
                                                  fontWeight: FontWeight.w500,
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
                                          width: 170,
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
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          orders[index].statusPayment ==
                                                  'PENDING'
                                              ? 'Chờ thanh toán'
                                              : 'Đã thanh toán ${orders[index].paymentMethods}',
                                          style: TextStyle(
                                              color:
                                                  orders[index].statusPayment ==
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
                                                overflow: TextOverflow.ellipsis,
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
                                          "Tổng thanh toán: ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${formatPrice(orders[index].totalPayment)}đ",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        const Spacer(),
                                        orders[index].statusOrder == "PENDING"
                                            ? GestureDetector(
                                                onTap: () async {
                                                  Loading(context);
                                                  await changeStatusOrder(
                                                      orders[index].id,
                                                      'CANCEL');
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);

                                                  setState(() {
                                                    orders.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.red[400],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      "Hủy đơn hàng",
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
                                            : SizedBox(),
                                        orders[index].statusOrder == "DELIVERED"
                                            ? GestureDetector(
                                                onTap: () async {
                                                  Loading(context);
                                                  await changeStatusOrder(
                                                      orders[index].id,
                                                      'COMPLETED');
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    orders[index].statusOrder =
                                                        'COMPLETED';
                                                  });
                                                },
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green[400],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      "Đã nhận hàng",
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
                                            : orders[index].statusOrder ==
                                                        "COMPLETED" &&
                                                    orders[index].rating ==
                                                        false
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddFeedBackScreen(
                                                            order:
                                                                orders[index],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        width: 90,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            "Đánh giá",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : orders[index].statusOrder ==
                                                            "COMPLETED" &&
                                                        orders[index].rating ==
                                                            true
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
                                                                .grey[200],
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "Bạn đã đánh giá",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox()
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
                      );
                    }),
              );
            }
          }
        });
  }
}
