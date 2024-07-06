import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItemWidget extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String sellerName;
  final String paymenMethods;
  final DateTime? paymentDate;
  final int totalPayment;

  const ListItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.sellerName,
    required this.paymenMethods,
    this.paymentDate,
    required this.totalPayment,
  });

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: 80,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(48, 96, 96, 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        'assets/images/dog_banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 4,
            ),
            SizedBox(
              width: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'đ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(48, 96, 96, 1.0),
                                fontWeight: FontWeight.bold,
                                decoration:
                                    TextDecoration.underline, // Gạch đít
                              ),
                            ),
                            TextSpan(
                                text: NumberFormat('#,##0', 'vi_VN').format(widget.totalPayment),
                                style: const TextStyle(
                                  fontSize: 16, // Kích thước văn bản
                                  color: Color.fromRGBO(
                                      48, 96, 96, 1.0), // Màu sắc văn bản
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.sellerName,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.paymentDate == null
                        ? "Chưa thanh toán"
                        : "Hoàn tất chuyển khoản vào ${widget.paymentDate!.day}/${widget.paymentDate!.month}/${widget.paymentDate!.year} ${widget.paymentDate!.hour}:${widget.paymentDate!.minute}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Giá thú cưng: ${NumberFormat('#,##0', 'vi_VN').format(int.parse(widget.price))} đ",
                    style: const TextStyle(
                        fontSize: 13, color: Color.fromRGBO(48, 96, 96, 1.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
