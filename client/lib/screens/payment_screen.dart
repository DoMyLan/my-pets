import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/payment_VNPAY.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/services/order/voucherApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var pet;
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

  TextEditingController voucherText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getClient();
    currentClient = widget.currentClient;
    transportFee = calculateShippingCost(calculateDistance(
        widget.currentClient.location,
        widget.pet.centerId != null
            ? widget.pet.centerId!.location
            : widget.pet.giver!.location));
    totalFee = int.parse(widget.pet.price) + transportFee;
    priceProduct = int.parse(widget.pet.price);
    totalPayment = int.parse(widget.pet.price) + transportFee;
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? message;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Địa chỉ nhận hàng',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.7, // Chiều rộng tối đa
                            child: Text(
                              currentClient.address,
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            0), // Điều chỉnh lề bên trái và bên phải của Divider
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 5,
                      height: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.pet.centerId != null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileCenterPage(
                                centerId: widget.pet.centerId!.id,
                                petId: widget.pet.id,
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userId: widget.pet.giver!.id),
                            ),
                          );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            widget.pet.centerId != null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileCenterPage(
                                        centerId: widget.pet.centerId!.id,
                                        petId: null,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          userId: widget.pet.giver!.id),
                                    ),
                                  );
                          },
                          child: Text(
                            widget.pet.centerId != null
                                ? widget.pet.centerId!.name
                                : widget.pet.giver!.firstName +
                                    ' ' +
                                    widget.pet.giver!.lastName,
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
                            widget.pet.centerId != null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileCenterPage(
                                        centerId: widget.pet.centerId!.id,
                                        petId: widget.pet.id,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          userId: widget.pet.giver!.id),
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
                              'Breed: ${widget.pet.breed}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Price: ${widget.pet.price} đ',
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
                const Row(
                  children: [
                    Icon(Icons.wallet_giftcard,
                        color: Color.fromARGB(255, 209, 191, 28)),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Voucher của Center',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: voucherText,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã voucher',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        if (voucherProduct == 0 &&
                            voucherShipping == 0 &&
                            voucherTotal == 0) {
                          Loading(context);
                          var voucher = await applyVoucher(voucherText.text);
                          Navigator.of(context).pop();
                          setState(() {
                            if (voucher != null) {
                              if (voucher.type == "Product") {
                                voucherProduct = min(
                                    voucher.discount * priceProduct,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - voucherProduct;
                              } else if (voucher.type == "Shipping") {
                                voucherShipping = min(
                                    voucher.discount * transportFee,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - transportFee;
                              } else {
                                voucherTotal = min(voucher.discount * totalFee,
                                    voucher.maxDiscount);
                                totalPayment = totalFee - voucherTotal;
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
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tin nhắn: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Lưu ý cho Trung tâm...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey.shade400)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 10,
                  height: 1,
                ),
                const SizedBox(height: 20.0),
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

                const SizedBox(height: 20.0),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(
                  height: 20,
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
                        '${widget.pet.price} đ',
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
                  GestureDetector(
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
                            message = await createOrder(
                                currentClient.id,
                                widget.pet.centerId != null ? true : false,
                                widget.pet.centerId != null
                                    ? widget.pet.centerId.id
                                    // ignore: prefer_null_aware_operators
                                    : widget.pet.giver == null
                                        ? null
                                        : widget.pet.giver.id,
                                widget.pet,
                                currentClient.address,
                                transportFee,
                                voucherText.text,
                                voucherProduct,
                                voucherShipping,
                                voucherTotal,
                                totalFee,
                                totalPayment,
                                _paymentMethod == 0
                                    ? "COD"
                                    : "ONLINE");
                            Navigator.of(context).pop();
                            if (message != "Create order successfully!") {
                              setState(() {
                                voucherProduct = 0;
                                voucherShipping = 0;
                                voucherTotal = 0;
                                totalPayment = totalFee;
                              });
                            }
                            if (message == "Create order successfully!" && _paymentMethod == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VNPAY()));
                            }

                            if (message != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Thông báo'),
                                    content:
                                        message == "Create order successfully!"
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
                            }

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
