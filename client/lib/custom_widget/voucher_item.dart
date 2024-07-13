import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/models/voucher_model.dart';


class VoucherItemSelected extends StatefulWidget {
  final Voucher voucher;
  final ValueChanged<bool>? onChanged;
  const VoucherItemSelected(
      {super.key, required this.voucher, this.onChanged});

  @override
  State<VoucherItemSelected> createState() => _VoucherItemSelectedState();
}

class _VoucherItemSelectedState extends State<VoucherItemSelected> {
  bool isSelected = false;
  Voucher? voucher;

  @override
  void initState() {
    super.initState();
    voucher = widget.voucher;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        padding: const EdgeInsets.all(4),
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
                width: 98.0,
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
                        voucher!.type == 'Shipping'
                            ? FontAwesomeIcons.truck
                            : voucher!.type == 'Product'
                                ? FontAwesomeIcons.cat
                                : FontAwesomeIcons.cartArrowDown,
                        size: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        voucher!.type == 'Shipping'
                            ? 'Vận chuyển'
                            : voucher!.type == 'Product'
                                ? 'Thú cưng'
                                : 'Tổng đơn hàng',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
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
                    'Giảm ${voucher!.discount}% tối đa ${voucher!.maxDiscount}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mua thú cưng tại trung tâm',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(
                        height: 25,
                        width: 90,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSelected = !isSelected;
                              widget.onChanged?.call(isSelected);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: isSelected
                                ? mainColor
                                : Colors
                                    .white, // Use backgroundColor instead of primary
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Sắp hết hạn: Còn ${voucher!.endDate.difference(DateTime.now()).inDays} ngày',
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(
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
                      const SizedBox(
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
          ],
        ),
      ),
    );
  }
}
