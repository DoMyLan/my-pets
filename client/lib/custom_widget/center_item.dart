import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:found_adoption_application/models/center_hot_model.dart';
import 'package:found_adoption_application/screens/guest/home_guest.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center_new.dart';

// void main() {
//   runApp(MaterialApp(
//     home: CenterItem(),
//   ));
// }

// ignore: must_be_immutable
class CenterItem extends StatefulWidget {
  late CenterHot centerHot;

  CenterItem({super.key, required this.centerHot});
  @override
  State<CenterItem> createState() => _CenterItemState();
}

class _CenterItemState extends State<CenterItem> {
  late CenterHot centerHot;

  @override
  void initState() {
    super.initState();
    centerHot = widget.centerHot;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileCenter(
                  centerId: centerHot.id,
                ),
              ),
            );
          },
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 145,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      centerHot.avatar,
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 130.0,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          centerHot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          centerHot.aboutMe,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Số lượng thú cưng đã  bán
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sell,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${centerHot.sold} đã bán',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),

                              //đánh giá sao
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${centerHot.rating}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),

                              //khoảng cách
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.social_distance,
                                    color: Colors.green,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '6.4 km',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ]),

                        const SizedBox(
                          height: 3,
                        ),

                        onPressFollow(
                            follow: centerHot.follow, id: centerHot.id),

                        //Follow
                        // ElevatedButton(
                        //   onPressed: () async {},
                        //   style: ElevatedButton.styleFrom(
                        //     minimumSize: const Size(190, 30),
                        //     foregroundColor: Colors.white,
                        //     backgroundColor:
                        //         const Color.fromRGBO(48, 96, 96, 1.0),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     textStyle: const TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   child: const Text('Theo dõi ngay'),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
