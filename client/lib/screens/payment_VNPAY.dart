import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/order.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
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
          'https://sandbox.vnpayment.vn/merchantv2/', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
      ipAdress: '59.153.254.38',
      vnpayHashKey:
          'UNWJIMZPXWPGBPYFGXJKADCYSIQPDBVX', //vnpay hash key, get from vnpay
      vnPayHashType: VNPayHashType
          .HMACSHA512, //hash type. Default is HmacSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2
    );
    
    VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
        setState(() async {
          responseCode = params['vnp_ResponseCode'];
          if (responseCode == '00') {
            await confirmPayment(widget.orderId);
          } else {
            // Do something
          }
        });
      },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Response Code: $responseCode'),
            TextButton(
              onPressed: onPayment,
              child: const Text('20.0000'),
            ),
          ],
        ),
      ),
    );
  }
}
