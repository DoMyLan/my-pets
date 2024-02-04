import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/adopt.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/adopt/adopt.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusAdoptUser extends StatefulWidget {
  const StatusAdoptUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatusAdoptUserState createState() => _StatusAdoptUserState();
}

class _StatusAdoptUserState extends State<StatusAdoptUser>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Adopt>>? adoptsPENFuture;
  Future<List<Adopt>>? adoptsACCFuture;
  Future<List<Adopt>>? adoptsCANFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    adoptsPENFuture = getStatusAdoptUser("PENDING");
    adoptsACCFuture = getStatusAdoptUser("ACCEPTED");
    adoptsCANFuture = getStatusAdoptUser("CANCELLED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuFrameUser(
                            userId: currentClient.id,
                          )),
                );
              } else if (currentClient.role == 'CENTER') {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuFrameCenter(centerId: currentClient.id)),
                );
              }
            }
          },
        ),
        title: const Text(
          'Adoption Status',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(40.0), // Điều chỉnh chiều cao mong muốn
          child: TabBar(
            controller: _tabController,
            labelColor: Color.fromRGBO(48, 96, 96, 1.0),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Accept'),
              Tab(text: 'Cancel'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AdoptionTabView(
            status: 'Pending',
            adoptFuture: adoptsPENFuture,
          ),
          AdoptionTabView(
            status: 'Accept',
            adoptFuture: adoptsACCFuture,
          ),
          AdoptionTabView(
            status: 'Cancel',
            adoptFuture: adoptsCANFuture,
          ),
        ],
      ),
    );
  }
}

class AdoptionTabView extends StatelessWidget {
  final String status;
  final Future<List<Adopt>>? adoptFuture;

  const AdoptionTabView(
      {super.key, required this.status, required this.adoptFuture});

  Widget _buildAdoptionRequestCard(BuildContext context, Adopt adopt) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileCenterPage(
                                  centerId: adopt.centerId!
                                      .id) // Thay thế bằng tên lớp tương ứng
                              ));
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(adopt.centerId!.avatar),
                    )),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileCenterPage(
                                        centerId: adopt.centerId!
                                            .id) // Thay thế bằng tên lớp tương ứng
                                    ));
                          },
                          child: Text(
                            '${adopt.centerId!.name}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(48, 96, 96, 1.0),
                            ),
                          )),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.location_on_outlined,
                      //       size: 16.0,
                      //       color: Color.fromRGBO(48, 96, 96, 1.0),
                      //     ),
                      //     Text(
                      //       '${adopt.userId!.address}', // Thay đổi bằng biến chứa địa chỉ của người dùng
                      //       style: const TextStyle(
                      //         fontSize: 15.0,
                      //         color: Color.fromRGBO(48, 96, 96, 1.0),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 16.0,
                              color: Color.fromRGBO(48, 96, 96, 1.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${adopt.centerId!.address}',
                              style: TextStyle(
                                  fontSize: 14.0, fontStyle: FontStyle.italic),
                              softWrap: true,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            // Thông tin thú cưng
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần "Contact"
                const Text(
                  'Contact:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Khoảng cách giữa email và số điện thoại
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16.0,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                          const SizedBox(width: 4.0),
                          InkWell(
                            onLongPress: () {
                              _copyToClipboard('${adopt.centerId!.phoneNumber}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Copied to Clipboard: ${adopt.centerId!.phoneNumber}'),
                                ),
                              );
                            },
                            onTap: () {
                              makePhoneCall(
                                  'tel:${adopt.centerId!.phoneNumber}');
                            },
                            child: Text(
                              '${adopt.centerId!.phoneNumber}', // Thay đổi bằng biến chứa số điện thoại của người dùng
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(48, 96, 96, 1.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3,
                  width: 3.0,
                ),

                RichText(
                  text: TextSpan(
                    text: 'Requests adopt:   ',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                      color: Colors.black, // Màu sắc cho phần "Requests adopt"
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: adopt.petId!.namePet,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold, // Làm cho petName in đậm
                          color: Color.fromRGBO(
                              48, 96, 96, 1.0), // Màu sắc cho petName
                        ),
                      ),
                    ],
                  ),
                ),

                // Tên thú cưng
              ],
            ),
            const SizedBox(
              width: 3.0,
            ),
            // Ảnh thú cưng
            GestureDetector(
                onTap: () {
                  //
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    '${adopt.petId!.images[0]}', // Đường dẫn ảnh thú cưng
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                )),
            const SizedBox(
              height: 5.0,
            ),
            // lời nhắn
            Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color.fromRGBO(48, 96, 96, 1.0), // Màu viền
                  width: 2.0, // Độ dày viền
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // Điều chỉnh độ đổ bóng
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      'Express interest in adoption',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic, // Đặt chữ nghiêng
                        decoration: TextDecoration.underline, // Thêm gạch đít
                        decorationColor: Colors.black, // Màu của gạch đít
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      adopt.descriptionAdoption.toString(),
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (adopt.cancelledReasonCenter != 'Nothing' ||
                    adopt.cancelledReasonUser != 'Nothing')
                ? Container(
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color:
                            const Color.fromRGBO(48, 96, 96, 1.0), // Màu viền
                        width: 2.0, // Độ dày viền
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // Điều chỉnh độ đổ bóng
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          adopt.cancelledReasonCenter != 'Nothing'
                              ? const Text(
                                  'Reason center cancel',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontStyle:
                                        FontStyle.italic, // Đặt chữ nghiêng
                                    decoration: TextDecoration
                                        .underline, // Thêm gạch đít
                                    decorationColor:
                                        Colors.red, // Màu của gạch đít
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(),
                          adopt.cancelledReasonUser != 'Nothing'
                              ? const Text(
                                  'Reason user cancel',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontStyle:
                                        FontStyle.italic, // Đặt chữ nghiêng
                                    decoration: TextDecoration
                                        .underline, // Thêm gạch đít
                                    decorationColor:
                                        Colors.red, // Màu của gạch đít
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 3.0),
                          Text(
                            adopt.cancelledReasonCenter != 'Nothing'
                                ? adopt.cancelledReasonCenter.toString()
                                : adopt.cancelledReasonUser.toString(),
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 6.0),

            // Nút Accept và Cancel
            if (status == 'Pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _showDeleteConfirmationDialog(context, adopt.id);
                      // ignore: use_build_context_synchronously
                    },
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: const Color.fromRGBO(241, 95, 4, 1),
                      // ignore: deprecated_member_use
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Điều này sẽ bo góc
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Adopt>? adopt;
    return FutureBuilder(
        future: adoptFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Please try again later'));
          } else if (snapshot.hasData) {
            adopt = snapshot.data;
            if (adopt!.isNotEmpty) {
              return ListView.builder(
                itemCount: adopt!.length,
                itemBuilder: (context, index) {
                  return _buildAdoptionRequestCard(context, adopt![index]);
                },
              );
            } else {
              return const Center(
                child: Icon(
                  Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                  size: 48.0,
                  color: Colors.grey,
                ),
              );
            }
          }
          return const Center();
        });
  }

  Future<void> _showDeleteConfirmationDialog(context, String petId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm cancel'),
          content: const Text('Are you sure you want to cancel this request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Loading(context);
                await changeStatusAdoptUser(petId, "CANCELLED");
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StatusAdoptUser() // Thay thế bằng tên lớp tương ứng
                        ));
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch(phoneNumber)) {
      // ignore: deprecated_member_use
      await launch(phoneNumber);
    } else {
      throw 'Không thể gọi điện thoại';
    }
  }
}
