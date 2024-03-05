import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:found_adoption_application/utils/consts.dart';


class PaymentMethod extends StatefulWidget {
  PaymentMethod({super.key,});
  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId: CLIENT_ID,
                            secretKey: SECRET_KEY,
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '10.12', //tổng tiền thực phải trả (include: phí vận chuyển, khuyến mãi,...)
                                  "currency": "USD", //loại tiền tệ thanh toán
                                  "details": {
                                    "subtotal": '10.12',   //số tiền trc khi áp dụng phí vận chuyển hoặc thuế
                                    "shipping": '0',      //phí vận chuyển
                                    "shipping_discount": 0   //giảm giá phí vận chuyển
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",   //tên sản phẩm
                                      "quantity": 1,    //số lượng 
                                      "price": '10.12',   //giá tiền thực của sản phẩm
                                      "currency": "USD"   //loại tiền tệ là dollar
                                    }
                                  ],

                                  // Fill Information current_client
                                  "shipping_address": {
                                    "recipient_name": "Đỗ Mỹ Lan",
                                    "line1": "14/32, Hồ Văn Tư, Tp. Thủ Đức",
                                    "line2": "",
                                    "city": "Tp. Hồ Chí Minh",
                                    "country_code": "VN",
                                    "postal_code": "73301",
                                    "phone": "0799353524",
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
                            }),
                      ),
                    )
                  },
              child: const Text(
                        'Phương thức thanh toán (Nhấn để chọn)',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 99, 182, 124),
                        ),
                      ),);
       
  }
}
