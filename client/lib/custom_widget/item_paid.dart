import 'package:flutter/material.dart';


class ListItemWidget extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String sellerName;
  // final String paymentStatus;
  // final String paymentDate;



  const ListItemWidget({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.sellerName,
    // required this.paymentStatus,
    // required this.paymentDate,

  
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
                      color: Color.fromRGBO(48, 96, 96, 1.0),
                      borderRadius: BorderRadius.circular(10)
                    ),
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
            Container(
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
                            TextSpan(
                              text: 'đ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(48, 96, 96, 1.0),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline, // Gạch đít
                              ),
                            ),
                            TextSpan(
                                text: widget.price,
                                style: TextStyle(
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
                    "Hoàn tất chuyển khoản vào 13 Th08 2023",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Đã chuyển khoản cho người bán",
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
