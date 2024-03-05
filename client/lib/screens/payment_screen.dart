import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/orders_screen.dart';
import 'package:found_adoption_application/screens/payment_method.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
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
  var transportFee = 0;
  var totalFee = 0;

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
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool success;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Thanh toán'),
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
                                  centerId: widget.pet.centerId!.id),
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
                      const SizedBox(
                        width: 12,
                      ),
                      const Text('View'),
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
                Container(
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
                        decoration: const InputDecoration(
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
                      onPressed: () {},
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 4,
                    ),

                    //KHÔNG XÓA ĐOẠN CODE NÀY NHA

                    // Text(
                    //   'Phương thức thanh toán (Nhấn để chọn)',
                    //   style: TextStyle(
                    //     fontSize: 14.0,
                    //     color: Color.fromARGB(255, 99, 182, 124),
                    //   ),
                    // ),

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
                    // ),      //KHÔNG XÓA ĐOẠN CODE NÀY NHA
                    
                    PaymentMethod()]    //ĐỂ TẠM Ở ĐÂY ĐỂ TEST THANH TOÁN PAYPALS
                ),
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
                      'Chi tiết thanh toán',
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
                        'Tổng tiền hàng',
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
                ]),
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
                        '$totalFee đ',
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
                            success = await createOrder(
                                currentClient.id,
                                currentClient.role == 'CENTER' ? true : false,
                                currentClient.role == 'CENTER'
                                    ? widget.pet.centerId.id
                                    : widget.pet.giver.id,
                                widget.pet,
                                currentClient.address,
                                transportFee,
                                totalFee);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Orders()));
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
