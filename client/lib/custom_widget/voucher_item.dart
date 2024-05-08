import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/main.dart';


// // Model cho voucher
// class Voucher {
//   final String id;
//   final String type;
//   final String code;
//   final String description;

//   Voucher(
//       {required this.id,
//       required this.type,
//       required this.code,
//       required this.description});
// }

class VoucherItemSelected extends StatefulWidget {
  final String type;
  const VoucherItemSelected({super.key, required this.type});

  @override
  State<VoucherItemSelected> createState() => _VoucherItemSelectedState();
}

class _VoucherItemSelectedState extends State<VoucherItemSelected> {
  bool isSelected = false;
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width ,
        height: 120,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                width: 110.0,
                height: 122.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: mainColor,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: -5,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.type.toString() == 'Shipping'
                            ? FontAwesomeIcons.truck
                            : FontAwesomeIcons.cat,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.type.toString() == 'Shipping' ? 'Shipping' : 'Coupon',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ))
            ]),
            const SizedBox(width: 4.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giảm tối đa 50k',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đơn tối thiếu 300k',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      Container(
                        height: 25,
                        width: 90,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSelected = !isSelected;
                            });
                          },
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: isSelected
                                ? mainColor
                                : Colors
                                    .white, // Use backgroundColor instead of primary
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Sắp hết hạn: Còn 2 ngày',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: mainColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          'Chỉ áp dụng cho 1 số đơn hàng nhất định',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       height: 20,
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           isSelected = !isSelected;
            //         });
            //       },
            //       child: isSelected
            //           ? Icon(
            //               Icons.check,
            //               color: Colors.white,
            //               size: 20,
            //             )
            //           : null, // Icon hoặc child widget để hiển thị khi được chọn
            //       style: ElevatedButton.styleFrom(
            //         shape: CircleBorder(), // Tạo hình tròn cho nút

            //         primary: isSelected
            //             ? mainColor
            //             : Colors.white, // Màu nền của nút
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
