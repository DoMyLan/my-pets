import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/bottom_sheet.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  late DateTime start;

  late DateTime end;
  DateTime? birthday = DateTime.parse('2001-01-01') as DateTime?;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Voucher',
          style: TextStyle(
              color: Color.fromRGBO(48, 96, 96, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuFrameUser(
                      userId: currentClient.id,
                    ),
                  ),
                );
              } else if (currentClient.role == 'CENTER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MenuFrameCenter(centerId: currentClient.id),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 60,
          ),
          voucherItem('Thú cưng', FontAwesomeIcons.dog),
          const SizedBox(
            height: 16,
          ),
          voucherItem('Giao hàng', FontAwesomeIcons.truck),
          const SizedBox(
            height: 16,
          ),
          voucherItem('Tổng đơn hàng', FontAwesomeIcons.cartShopping),
          const SizedBox(
            height: 16,
          ),
          voucherItem('Giao hàng', FontAwesomeIcons.truck),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: false,
            context: context,
            builder: (BuildContext context) {
              //widget modelbottomsheet
              return CustomModalBottomSheet();
            },
          );
        },
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

 

  Widget voucherItem(String petText, IconData iconPet) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 110.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: mainColor,
                ),
                // Placeholder for pet image
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GIẢM 50% TỐI ĐA 50K',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        'Bắt đầu: 24/03/2024',
                        style: const TextStyle(fontSize: 11.0),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Kết thúc: 30/03/2024',
                        style: const TextStyle(fontSize: 11.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số lượng còn lại: 50',
                        style: TextStyle(fontSize: 11.0),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(color: mainColor),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text(
                            'Sử dụng',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: mainColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.grey,
                          ),
                          Text(
                            'Hiệu lực sau: 8 giờ',
                            style: const TextStyle(
                                fontSize: 10.0, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey,
                          ),
                          Text(
                            'Chưa có hiệu lực',
                            style: const TextStyle(
                                fontSize: 10.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 4, 15, 4),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 168, 57),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                petText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 65,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
              ),
              child: Container(
                color: Colors.grey.shade400,
                child: Row(
                  children: [
                    Text(
                      'VOUCHER_CODE',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.copy,
                          size: 18,
                        ))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
              ),
              child: Icon(
                iconPet,
                color: Colors.yellow.withOpacity(0.8),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
