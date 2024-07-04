import 'dart:math';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/payment_VNPAY.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center_new.dart';
import 'package:found_adoption_application/screens/user_screens/show_all_voucher.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/services/order/voucherApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  Pet pet;
  var currentClient;
  PaymentScreen({super.key, required this.pet, required this.currentClient});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var currentClient;
  var priceProduct = 0;
  var transportFee = 0;
  var totalFee = 0;
  var voucherProduct = 0;
  var voucherShipping = 0;
  var voucherTotal = 0;
  var totalPayment = 0;
  late int _paymentMethod = 0;

  late String address = '';
  var newAddress = '';
  late String? voucherCode = "";
  var orderSuccess = false;

  TextEditingController voucherText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getClient();
    currentClient = widget.currentClient;
    transportFee = calculateShippingCost(calculateDistance(
        widget.currentClient.location, widget.pet.centerId!.location));
    // kiểm tra ngày hiện tại có nằm trong ngày giảm giá không
    if (widget.pet.reducePrice > 0) {
      var now = DateTime.now();
      var start = widget.pet.dateStartReduce;
      var end = widget.pet.dateEndReduce;
      if (now.isAfter(start!) && now.isBefore(end!)) {
        priceProduct = int.parse(widget.pet.price) - widget.pet.reducePrice > 0
            ? int.parse(widget.pet.price) - widget.pet.reducePrice
            : 0;
        totalFee = (int.parse(widget.pet.price) - widget.pet.reducePrice > 0
                ? int.parse(widget.pet.price) - widget.pet.reducePrice
                : 0) +
            transportFee;
        totalPayment = (int.parse(widget.pet.price) - widget.pet.reducePrice > 0
                ? int.parse(widget.pet.price) - widget.pet.reducePrice
                : 0) +
            transportFee;
      } else {
        priceProduct = int.parse(widget.pet.price);
        totalFee = int.parse(widget.pet.price) + transportFee;
        totalPayment = int.parse(widget.pet.price) + transportFee;
      }
    } else {
      priceProduct = int.parse(widget.pet.price);
      totalFee = int.parse(widget.pet.price) + transportFee;
      totalPayment = int.parse(widget.pet.price) + transportFee;
    }

    address =
        "${widget.currentClient.firstName} ${widget.currentClient.lastName}, ${widget.currentClient.phoneNumber}, ${widget.currentClient.address}";
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? orderId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Thông tin đơn hàng'),
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Địa chỉ nhận hàng',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        String newAddress = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Nhập địa chỉ mới'),
                            content: TextField(
                              controller: TextEditingController(text: address),
                              onChanged: (value) {
                                address = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(address);
                                },
                              ),
                            ],
                          ),
                        );
                        if (newAddress != null) {
                          setState(() {
                            address = newAddress;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.7, // Chiều rộng tối đa
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                      ),
                      softWrap: true,
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            0), // Điều chỉnh lề bên trái và bên phải của Divider
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileCenter(centerId: widget.pet.centerId!.id),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileCenter(
                                    centerId: widget.pet.centerId!.id),
                              ),
                            );
                          },
                          child: Text(
                            widget.pet.centerId!.name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileCenter(
                                    centerId: widget.pet.centerId!.id),
                              ),
                            );
                          },
                          child: const Text('Xem bài viết')),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnimalDetailScreen(
                                  petId: widget.pet.id,
                                  currentId: currentClient,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: const Color.fromARGB(255, 248, 245, 245),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300],
                          ),
                          // Placeholder for pet image
                          child: Image.network(
                            widget.pet.images[0],
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.pet.namePet}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Giống: ${widget.pet.breed}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Giá: ${widget.pet.price} đ',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 15.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard_outlined,
                      color: Colors.amberAccent,
                    ),
                    const Text(
                      'Voucher',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          voucherProduct = 0;
                          voucherShipping = 0;
                          voucherTotal = 0;
                          totalPayment = totalFee;
                        });
                        voucherCode = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => VoucherScreen(
                                    centerId: widget.pet.centerId!.id,
                                    selectedVoucherCode: voucherCode))));
                        if (voucherProduct == 0 &&
                            voucherShipping == 0 &&
                            voucherTotal == 0) {
                          Loading(context);
                          var voucher = await applyVoucher(voucherCode);
                          Navigator.of(context).pop();
                          setState(() {
                            voucherCode = voucherCode;
                            if (voucher != null) {
                              if (voucher.type == "Product") {
                                voucherProduct = min(
                                    voucher.discount * priceProduct,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - voucherProduct > 0
                                    ? totalFee - voucherProduct
                                    : 0;
                              } else if (voucher.type == "Shipping") {
                                voucherShipping = min(
                                    voucher.discount * transportFee,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - transportFee > 0
                                    ? totalFee - voucherShipping
                                    : 0;
                              } else {
                                voucherTotal = min(voucher.discount * totalFee,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - voucherTotal > 0
                                    ? totalFee - voucherTotal
                                    : 0;
                              }
                            }
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Thông báo'),
                                content:
                                    const Text('Chỉ được áp dụng 1 voucher'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Đóng'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Row(
                        children: [
                          voucherProduct != 0 ||
                                  voucherShipping != 0 ||
                                  voucherTotal != 0
                              ? Text(
                                  'Giảm giá: ${voucherProduct != 0 ? voucherProduct : voucherShipping != 0 ? voucherShipping : voucherTotal} đ (Đã áp dụng)',
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.redAccent),
                                )
                              : const Text(
                                  'Chưa áp dụng voucher',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.redAccent),
                                ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ], //VoucherItemSelected(type: 'Product',)],
                ),
                const SizedBox(height: 5.0),

                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 10.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       'Tin nhắn: ',
                //       style: TextStyle(
                //         fontSize: 14.0,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 100,
                //     ),
                //     Expanded(
                //       child: TextFormField(
                //         decoration: InputDecoration(
                //             hintText: 'Lưu ý cho Trung tâm...',
                //             border: InputBorder.none,
                //             hintStyle: TextStyle(
                //                 fontSize: 15, color: Colors.grey.shade400)),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20.0),
                // Divider(
                //   color: Colors.grey.shade300,
                //   thickness: 1,
                //   height: 1,
                // ),
                // const SizedBox(height: 20.0),
                Column(
                  children: <Widget>[
                    const Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.red,
                        ),
                        Text(
                          'Chọn phương thức thanh toán',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 99, 182, 124),
                          ),
                        ),
                      ],
                    ),
                    RadioListTile(
                      value: 0,
                      groupValue: _paymentMethod,
                      title: const Text(
                        "Thanh toán bằng tiền mặt",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: _paymentMethod,
                      title: const Text(
                        "Thanh toán bằng VNPAY",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),

                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: ((context) => PaymentMethod())));
                //   },
                //   child: const Text(
                //     'Phương thức thanh toán (Nhấn để chọn)',
                //     style: TextStyle(
                //       fontSize: 14.0,
                //       color: Color.fromARGB(255, 99, 182, 124),
                //     ),
                //   ),
                // ),
//ĐỂ TẠM Ở ĐÂY ĐỂ TEST THANH TOÁN PAYPALS

                const SizedBox(height: 10.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Color.fromARGB(255, 209, 191, 28),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Chi tiết đơn hàng',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giá sản phẩm',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '$priceProduct đ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  voucherProduct != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Giảm giá sản phẩm',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              '-$voucherProduct đ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền phí vận chuyển',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '$transportFee đ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  voucherShipping != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Giảm giá vận chuyển',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              '-$voucherShipping đ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền hóa đơn',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '$totalFee đ',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  voucherTotal != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Giảm giá tổng hóa đơn',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              '-${voucherTotal} đ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thanh toán sau giảm giá',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      '$totalPayment đ',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Divider(
                //   color: Colors.grey.shade300,
                //   thickness: 1,
                //   height: 1,
                // ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0,
                        3), // Thay đổi offset để điều chỉnh vị trí của bóng đổ
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Tổng thanh toán',
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '$totalPayment đ',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  !orderSuccess
                      ? GestureDetector(
                          onTap: () {
                            // Xử lý sự kiện khi nhấn vào nút Đặt hàng
                            // Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: ((context) =>
                            //                  PaymentMethod())));
                          },
                          child: Container(
                            color: Colors.red,
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: TextButton(
                                child: const Text(
                                  'Đặt hàng',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  Loading(context);
                                  orderId = await createOrder(
                                      currentClient.id,
                                      widget.pet.centerId != null
                                          ? true
                                          : false,
                                      widget.pet.centerId!.id,
                                      widget.pet,
                                      address,
                                      transportFee,
                                      voucherText.text,
                                      voucherProduct,
                                      voucherShipping,
                                      voucherTotal,
                                      totalFee,
                                      totalPayment,
                                      _paymentMethod == 0 ? "COD" : "ONLINE",
                                      priceProduct);
                                  Navigator.of(context).pop();
                                  if (orderId != null) {
                                    setState(() {
                                      voucherProduct = 0;
                                      voucherShipping = 0;
                                      voucherTotal = 0;
                                      totalPayment = totalFee;
                                    });
                                  }
                                  if (orderId != null && _paymentMethod == 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VNPAY(
                                                  orderId: orderId.toString(),
                                                  totalPayment: double.parse(
                                                      totalPayment.toString()),
                                                )));
                                  }

                                  if (orderId != null) {
                                    setState(() {
                                      orderSuccess = true;
                                    });
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Thông báo'),
                                        content: orderId != null
                                            ? const Text("Đặt hàng thành công")
                                            : const Text("Chưa thể đặt hàng"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Đóng'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  //KHÔNG XÓA CODE Ở ĐÂY NHA
                                  // Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         PaymentMethod(success: success!,)));

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const Orders()));
                                },
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.grey,
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: TextButton(
                                  child: const Text(
                                    'Bạn đã đặt hàng thành công',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {}),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ProductPageState {}

int calculateShippingCost(double distance) {
  const double baseCostPerKm = 5000;
  const double additionalCostPerKm = 1000;
  const double baseDistance = 10;

  double cost;
  if (distance <= baseDistance) {
    cost = baseCostPerKm * distance;
  } else {
    cost = baseCostPerKm * baseDistance +
        additionalCostPerKm * (distance - baseDistance);
  }

  return cost.round();
}

//tính toán khoảng cách
double calculateDistance(
  currentAddress,
  otherAddress,
) {
  LatLng currentP = LatLng(
    double.parse(currentAddress.latitude),
    double.parse(currentAddress.longitude),
  );

  LatLng pDestination = LatLng(
    double.parse(otherAddress.latitude),
    double.parse(otherAddress.longitude),
  );

  double distance = Geolocator.distanceBetween(
    currentP.latitude,
    currentP.longitude,
    pDestination.latitude,
    pDestination.longitude,
  );

  return distance / 1000; // Chia cho 1000 để chuyển đổi sang đơn vị kilômét
}
