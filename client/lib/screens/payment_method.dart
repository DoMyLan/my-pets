import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:found_adoption_application/custom_widget/exchange_rate.dart';
import 'package:found_adoption_application/models/invoice.dart';
import 'package:found_adoption_application/services/order/paymentApi.dart';
import 'package:found_adoption_application/utils/consts.dart';

class PaymentMethod extends StatefulWidget {
  // final String success;
  PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  late Future<Invoice> invoiceDetail;
  late Future<double> amountInUSD;

  @override
  void initState() {
    super.initState();
    // invoiceDetail = getInvoice(widget.success);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Invoice>(
        future: invoiceDetail,
        builder: (BuildContext context, AsyncSnapshot<Invoice> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final Invoice invoice = snapshot.data!;
          return FutureBuilder<double>(
            future: PaymentConversion.convertVNDtoUSD(
                double.parse('${invoice.price}')),
            builder:
                (BuildContext context, AsyncSnapshot<double> amountSnapshot) {
              if (amountSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (amountSnapshot.hasError) {
                return Text('Error: ${amountSnapshot.error}');
              }
              final double convertedAmount = amountSnapshot.data!;

              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId: CLIENT_ID,
                        secretKey: SECRET_KEY,
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: [
                          {
                            "amount": {
                              "total": convertedAmount.toStringAsFixed(
                                  2), //tổng tiền thực phải trả (include: phí vận chuyển, khuyến mãi,...)
                              "currency": "USD",
                              "details": {
                                "subtotal": convertedAmount.toStringAsFixed(
                                    2), //số tiền trc khi áp dụng phí vận chuyển hoặc thuế
                                "shipping": '0', //phí vận chuyển
                                "shipping_discount": 0 //giảm giá phí vận chuyển
                              }
                            },
                            "description":
                                "The payment transaction description.",
                            "item_list": {
                              "items": [
                                {
                                  "name": invoice.petId.namePet,
                                  "quantity": 1,
                                  "price": convertedAmount.toStringAsFixed(2),   //giá tiền thực của sản phẩm
                                  "currency": "USD"
                                }
                              ],
                              "shipping_address": {
                                "recipient_name":
                                    '${invoice.buyer.firstName} ${invoice.buyer.lastName}',
                                "line1": invoice.address,
                                "line2": '',
                                "city": "Tp. Hồ Chí Minh",
                                "country_code": "VN",
                                "postal_code": "73301",
                                "phone": invoice.buyer.phoneNumber,
                                "state": "Trường Thọ"
                              },
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          print("onSuccess: $params");
                          //chuyển đến trang review đơn hàng đã đặt thành công, và hiển thị 1 Toast 'Thanh toán thành công'
                        },
                        onError: (error) {
                          print("onError: $error");
                          //Back lại trang đặt hàng, thực hiện lại phương thức thanh toán và hiển thị Toast 'Thành toán fail'
                        },
                        onCancel: (params) {
                          print('cancelled: $params');
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Chuyển đến trang thanh toán (Nhấn để tiếp tục)',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 99, 182, 124),
                  ),
                ),
              );
            },
          );
        });
  }
}
