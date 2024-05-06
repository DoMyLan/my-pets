import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';

class RevenueDetailScreen extends StatefulWidget {
  final String orderId;
  const RevenueDetailScreen({super.key, required this.orderId});

  @override
  State<RevenueDetailScreen> createState() => _RevenueDetailScreenState();
}

class _RevenueDetailScreenState extends State<RevenueDetailScreen> {
  Future<Order>? orderFuture;

  @override
  void initState() {
    orderFuture = getOrderDetailBySeller(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: orderFuture,
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
            Order order = snapshot.data as Order;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text('Chi tiết doanh thu'),
              ),
              body: Container(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Icon(
                                Icons.currency_exchange,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.statusOrder == "COMPLETED"
                                    ? "Đơn hàng đã hoàn thành"
                                    : order.statusOrder == "CANCEL"
                                        ? "Đơn hàng đã bị hủy"
                                        : "Đơn hàng chưa hoàn thành",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                order.statusPayment == "PAID"
                                    ? "Đã thanh toán cho người bán"
                                    : "Chưa thanh toán",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                order.statusPayment == "PAID"
                                    ? "Hoàn tất chuyển khoản vào ${order.datePaid}"
                                    : "Chưa có thông tin thanh toán",
                                // 'Hoàn tất chuyển khoản vào 15 Th08 2023',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //MÃ ĐƠN HÀNG
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mã đơn hàng',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text(
                                order.id.toUpperCase(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Icon(Icons.chevron_right)
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //TỔNG TIỀN SẢN PHẨM
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tổng tiền hàng',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text('đ ${order.petId.price}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Giá sản phẩm',
                                  style: TextStyle(fontSize: 15)),
                              Text('đ ${order.petId.price}')
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //KHUYẾN MÃI
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Khuyến mãi ${order.voucherProduct != 0 ? "thú cưng" : order.voucherShipping != 0 ? "vận chuyển" : "tổng đơn hàng"}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  'đ ${order.voucherProduct != 0 ? order.voucherProduct : order.voucherShipping != 0 ? order.voucherShipping : order.voucherTotal}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Trị giá khuyến mãi',
                                  style: TextStyle(fontSize: 15)),
                              Text(
                                  'đ ${order.voucherProduct != 0 ? order.voucherProduct : order.voucherShipping != 0 ? order.voucherShipping : order.voucherTotal}')
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //PHÍ VẬN CHUYỂN
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phí vận chuyển',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text('đ 0')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phí vận chuyển Người mua trả',
                                  style: TextStyle(fontSize: 15)),
                              Text('đ 9.000')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phí vận chuyển Trung tâm trợ giá',
                                  style: TextStyle(fontSize: 15)),
                              Text('đ 10.000')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phí vận chuyển thực tế',
                                  style: TextStyle(fontSize: 15)),
                              Text('đ 19.000')
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //DOANH THU
                    Container(
                      padding: EdgeInsets.all(8),
                      width: widthDevice,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Doanh thu',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Text('đ ${order.totalPayment}')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
