import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/order_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class VNPAY extends StatefulWidget {
  final String orderId;
  final double totalPayment;
  const VNPAY({super.key, required this.orderId, required this.totalPayment});

  @override
  State<VNPAY> createState() => _ExampleState();
}

class _ExampleState extends State<VNPAY> {
  String responseCode = '';

  void onPayment() async {
    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url:
          'https://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
      version: '2.0.1',
      tmnCode: 'HOG7GGV6', //vnpay tmn code, get from vnpay
      txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
      orderInfo:
          'Pay ${widget.totalPayment} VND', //order info, default is Pay Order
      amount: widget.totalPayment,
      returnUrl:
          'https://abc.com/return', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
      ipAdress: '59.153.254.38',
      vnpayHashKey:
          'UNWJIMZPXWPGBPYFGXJKADCYSIQPDBVX', //vnpay hash key, get from vnpay
      vnPayHashType: VNPayHashType
          .HMACSHA512, //hash type. Default is HmacSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2
    );

    VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) async {
        Loading(context);
        await confirmPayment(widget.orderId);
        Navigator.pop(context);
        setState(() {
          responseCode = params['vnp_ResponseCode'];
        });
      },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
      },
    );
    // closeInAppWebView();R
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: responseCode == ""
              ? <Widget>[
                  const Text('Thanh toán đơn hàng'),
                  TextButton(
                    onPressed: onPayment,
                    child: const Text('Thanh toán'),
                  ),
                  const Text('Lưu ý: Bạn không thể hủy đơn hàng sau khi thanh toán bằng VNPAY'),
                ]
              : responseCode == "00"
                  ? <Widget>[
                      const Text('Thanh toán đơn hàng thành công'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              var currentClient = await getCurrentClient();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuFrameUser(
                                    userId: currentClient.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Trở về trang chủ'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TheOrders(),
                                ),
                              );
                            },
                            child: const Text('Xem đơn hàng'),
                          ),
                        ],
                      ),
                    ]
                  : <Widget>[
                      const Text('Thanh toán đơn hàng thất bại'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              var currentClient = await getCurrentClient();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuFrameUser(
                                    userId: currentClient.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Trở về trang chủ'),
                          ),
                          TextButton(
                            onPressed: onPayment,
                            child: const Text('Thanh toán lại'),
                          ),
                        ],
                      ),
                    ],
        ),
      ),
    );
  }
}
