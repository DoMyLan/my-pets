import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/bottom_sheet.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/models/voucher_model.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/order/voucherApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:intl/intl.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherState();
}

class _VoucherState extends State<VoucherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 4, vsync: this);
  // ignore: prefer_typing_uninitialized_variables
  var currentClient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
                title: const Text('Voucher',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                centerTitle: true,
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
                  icon: const Icon(FontAwesomeIcons.bars),
                )),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: TabView(
                    tabController: _tabController,
                    centerId: currentClient!.id,
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    //widget modelbottomsheet
                    return FractionallySizedBox(
                      heightFactor: 0.75,
                      child: CustomModalBottomSheet(),
                    );
                  },
                );

                if (result != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VoucherScreen()));
                }
              },
              backgroundColor: mainColor,
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
class TabView extends StatelessWidget {
  String centerId;
  TabView({
    super.key,
    required TabController tabController,
    required this.centerId,
  }) : _tabController = tabController;

  final TabController _tabController;

  // ignore: recursive_getters
  BuildContext get context => context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750,
      child: Column(
        children: [
          TabBar(
            labelStyle: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
            controller: _tabController,
            labelColor: Colors.black,
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                    width: 2, style: BorderStyle.solid, color: Colors.black),
                insets: EdgeInsets.zero),
            unselectedLabelColor: Colors.grey,
            tabs: const <Widget>[
              Tab(text: 'Tất cả'),
              Tab(text: 'Chưa có hiệu lực'),
              Tab(text: 'Có hiệu lực'),
              Tab(text: 'Hết hiệu lực'),
            ],
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 221, 221, 221),
              child: TabBarView(
                controller: _tabController,
                children: [
                  VoucherItem(centerId: centerId, use: -1),
                  VoucherItem(centerId: centerId, use: 0),
                  VoucherItem(centerId: centerId, use: 1),
                  VoucherItem(centerId: centerId, use: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherItem extends StatefulWidget {
  final String centerId;
  final int use;
  const VoucherItem({Key? key, required this.centerId, required this.use})
      : super(key: key);
  @override
  State<VoucherItem> createState() => _VoucherItemState();
}

class _VoucherItemState extends State<VoucherItem> {
  Color mainColor = const Color.fromRGBO(48, 96, 96, 1.0);
  Future<List<Voucher>>? vouchersFuture;
  List<Voucher> vouchers = [];

  @override
  void initState() {
    super.initState();
    vouchersFuture = getVoucher(widget.centerId, widget.use);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: vouchersFuture,
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
            vouchers = snapshot.data as List<Voucher>;

            return SingleChildScrollView(
              child: SizedBox(
                height: 600,
                child: ListView.builder(
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 122.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero,
                                      color: mainColor,
                                    ),
                                    // Placeholder for pet image
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Giảm ${vouchers[index].discount}% tối đa ${vouchers[index].maxDiscount} VND',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // ignore: use_build_context_synchronously
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height: 113,
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title:
                                                              const Text('Sửa'),
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            final result =
                                                                await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                //widget modelbottomsheet
                                                                return CustomModalBottomSheet(
                                                                  voucher:
                                                                      vouchers[
                                                                          index],
                                                                );
                                                              },
                                                            );

                                                            if (result !=
                                                                null) {
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pushReplacement(
                                                                  // ignore: use_build_context_synchronously
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const VoucherScreen()));
                                                            }
                                                          },
                                                        ),
                                                        ListTile(
                                                          title:
                                                              const Text('Xóa'),
                                                          onTap: () async {
                                                            Loading(context);
                                                            await deleteVoucher(
                                                                vouchers[index]
                                                                    .id);

                                                            Navigator.pop(
                                                                context);
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const VoucherScreen()));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Bắt đầu: ${DateFormat('dd-MM-yyyy').format(vouchers[index].startDate)}',
                                            style:
                                                const TextStyle(fontSize: 11.0),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Kết thúc: ${DateFormat('dd-MM-yyyy').format(vouchers[index].endDate)}',
                                            style:
                                                const TextStyle(fontSize: 11.0),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width:
                                                115, // Đặt kích thước tối đa cho Text
                                            child: Text(
                                              'Số lượng còn lại: ${vouchers[index].quantity - vouchers[index].used!}',
                                              style: const TextStyle(
                                                  fontSize: 11.0),
                                              overflow: TextOverflow
                                                  .ellipsis, // Xác định cách xử lý khi vượt quá kích thước
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              //lỗi WidgetStateProperty chưa đc define
                                              // shape: WidgetStateProperty.all(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                              ),
                                              //lỗi WidgetStateProperty chưa đc define
                                              // side: WidgetStateProperty.all(
                                              side: MaterialStateProperty.all<
                                                  BorderSide>(
                                                BorderSide(color: mainColor),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                child: Text(
                                                  'Sử dụng',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: mainColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.schedule,
                                                color: Colors.grey,
                                                size: 10,
                                              ),
                                              vouchers[index]
                                                          .startDate
                                                          .difference(
                                                              DateTime.now())
                                                          .inHours <
                                                      0
                                                  ? Text(
                                                      'Hết hiệu lực sau: ${vouchers[index].endDate.difference(DateTime.now()).inHours} giờ',
                                                      style: const TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.grey),
                                                    )
                                                  : vouchers[index]
                                                              .endDate
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inHours <
                                                          0
                                                      ? const Text(
                                                          'Hết hạn',
                                                          style: TextStyle(
                                                              fontSize: 10.0,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      : Text(
                                                          'Có hiệu lực sau: ${vouchers[index].startDate.difference(DateTime.now()).inHours} giờ',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.grey,
                                                size: 10,
                                              ),
                                              vouchers[index]
                                                              .startDate
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inHours <
                                                          0 &&
                                                      vouchers[index]
                                                              .endDate
                                                              .difference(
                                                                  DateTime
                                                                      .now())
                                                              .inHours >
                                                          0
                                                  ? const Text(
                                                      'Có hiệu lực',
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.grey),
                                                    )
                                                  : const Text(
                                                      'Không có hiệu lực',
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Colors.grey),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 90,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 241, 168, 57),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Text(
                                    vouchers[index].type == "Product"
                                        ? 'Thú cưng'
                                        : vouchers[index].type == "Shipping"
                                            ? 'Giao hàng'
                                            : 'Tổng đơn hàng',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 65,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Container(
                                    width: 100,
                                    color: Colors.grey.shade400,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          vouchers[index].code,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                            color: Colors.white,
                                            child: const Icon(
                                              Icons.copy,
                                              size: 15,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 30,
                                bottom: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Icon(
                                    vouchers[index].type == "Product"
                                        ? FontAwesomeIcons.dog
                                        : vouchers[index].type == "Shipping"
                                            ? FontAwesomeIcons.truck
                                            : FontAwesomeIcons.cartShopping,
                                    color: Colors.yellow.withOpacity(0.8),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        });
  }
}
