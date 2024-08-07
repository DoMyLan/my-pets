import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/screens/adoption_screen.dart';

import 'package:found_adoption_application/screens/map_page.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/services/followApi.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:found_adoption_application/screens/change_password.dart';

class ProfileCenterPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final centerId;
  // ignore: prefer_typing_uninitialized_variables
  final petId;
  const ProfileCenterPage(
      {super.key, required this.centerId, required this.petId});

  @override
  State<ProfileCenterPage> createState() => _ProfileCenterPageState();
}

class _ProfileCenterPageState<T extends AdoptionScreen>
    extends State<ProfileCenterPage> {
  int selectedAnimalIconIndex = 0;
  Future<List<Post>>? petStoriesPosts;
  late Future<InfoCenter> centerFuture;
  late Future<List<Pet>?> petsFuture;
  late List<Pet> animals = [];
  // ignore: prefer_typing_uninitialized_variables
  var currentClient;
  late bool isLoading = true;
  late InfoCenter center;

  List<String> animalTypes = [
    'Cats',
    'Dogs',
    'Parrots',
    'Fish',
    'Fish',
  ];

  List<IconData> animalIcons = [
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.fish
  ];
  late AdoptionScreen adoptionScreen;

  @override
  void initState() {
    super.initState();
    adoptionScreen = AdoptionScreen(centerId: widget.centerId);

    if (widget.petId != null) {
      petStoriesPosts = getPostPet(widget.petId);
    } else {
      petStoriesPosts = getAllPostPersonal(widget.centerId);
    }
    centerFuture = getProfileCenter(context, widget.centerId);
    petsFuture = getAllPetOfCenter(widget.centerId);
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuFrameUser(
                            userId: currentClient.id,
                          )),
                );
              } else if (currentClient.role == 'CENTER') {
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuFrameCenter(centerId: currentClient.id)),
                );
              }
            }
          },
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25.0),
        ),
      ),
      body: FutureBuilder<InfoCenter>(
          future: centerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there is an error fetching data, show an error message
              return const Center(child: Text('Error'));
            } else {
              // If data is successfully fetched, display the form
              center = snapshot.data as InfoCenter;

              center.follower =
                  center.followerUser.length + center.followerCenter.length;

              if (currentClient.role == "USER") {
                center.follow = center.followerUser.contains(currentClient.id);
              } else {
                center.follow =
                    center.followerCenter.contains(currentClient.id);
              }

              if (center.status == 'HIDDEN') {
                if (currentClient.id != widget.centerId) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_off,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          'Trung tâm đã ẩn thông tin của mình',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  );
                }
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh đại diện
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar
                        InkWell(
                          onTap: () {
                            _showFullScreenImage(context, center.avatar);
                          },
                          child: Hero(
                            tag: 'avatarTag',
                            child: CircleAvatar(
                              radius: 40.0,
                              backgroundImage: NetworkImage(center.avatar),
                            ),
                          ),
                        ),

                        // Nút Follow và Edit Profile
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await follow_unfollow("", center.id);
                                setState(() {
                                  center.follow = !center.follow;
                                });
                              },
                              icon: const Icon(Icons.person_add,
                                  color: Colors.white),
                              label: Text(
                                center.follow ? 'Đang theo dõi' : 'Theo dõi',
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context)
                                    .primaryColor, // Đổi màu văn bản của nút
                              ),
                            ),
                            const SizedBox(width: 3.0),
                            currentClient.id == widget.centerId
                                ? PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: SizedBox(
                                          width: 175,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const EditProfileCenterScreen()));
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white),
                                            label: const Text('Sửa thông tin'),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),

                                      //Update Password
                                      PopupMenuItem(
                                        value: 1,
                                        child: SizedBox(
                                          width: 175,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdatePasswordScreen()));
                                            },
                                            icon: const Icon(Icons.password,
                                                color: Colors.white),
                                            label: const Text('Đổi mật khẩu'),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: SizedBox(
                                          width: 175,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _showBottomSheet(
                                                  center.id, center.status);
                                            },
                                            icon: const Icon(
                                                Icons.change_circle,
                                                color: Colors.white),
                                            label: const Text(
                                                'Thay đổi trạng thái'),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // Handle your logic based on selected value
                                    },
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.grey),
                                  )
                                : const SizedBox(width: .0),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Họ và Tên
                    Row(
                      children: [
                        // User's name
                        Text(
                          '${center.name} ',
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        // Status icon
                        Icon(
                          center.status == 'ACTIVE'
                              ? Icons.check_circle
                              : Icons.visibility_off,
                          color: center.status == 'ACTIVE'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Contact me
                    buildSectionHeader('Contact center', Icons.mail),
                    buildContactInfo(center.phoneNumber, Icons.phone, 'phone'),
                    buildContactInfo(center.email, Icons.email, 'email'),
                    buildContactInfo(
                        center.address,
                        const IconData(0xe3ab, fontFamily: 'MaterialIcons'),
                        'address'),
                    const SizedBox(height: 16.0),

                    // About me
                    buildSectionHeader('About center', Icons.info),
                    buildInfo(center.aboutMe),
                    const SizedBox(height: 16.0),

                    const SizedBox(height: 16.0),

                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: const Color.fromARGB(255, 176, 175, 175),
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                    ),

                    // List các bài viết đã đăng
                    buildSectionHeader('Bài viết đã đăng', Icons.library_books),

                    // Widget chứa TabBar và TabBarView
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          buildPostsList(petStoriesPosts!),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  // Widget hiển thị danh sách bài đăng
  Widget buildPostsList(Future<List<Post>>? posts) {
    return FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const errorWidget();
          } else {
            List<Post>? postList = snapshot.data;
            if (postList!.isEmpty) {
              return const Center(
                child: Text('Không có bài viết nào'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: postList.length,
              itemBuilder: (context, index) => PostCard(snap: postList[index]),
            );
          }
        });
  }

  //hiển thị danh sách PetAdopt
  // Widget buildAdoptionList() {
  //   final deviceWidth = MediaQuery.of(context).size.width;
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 24),
  //       child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(25),
  //               topRight: Radius.circular(25),
  //             ),
  //             color: Theme.of(context).primaryColor.withOpacity(0.06)),
  //         height: 500,
  //         child: Column(
  //           children: [
  //             //CHI TIẾT VỀ THÔNG TIN CÁC PET ĐƯỢC NHẬN NUÔI
  //             Expanded(
  //               child: FutureBuilder<List<Pet>>(
  //                   future: petsFuture,
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return const Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     } else if (snapshot.hasError) {
  //                       return const Center(
  //                           child: Text('Please try again later'));
  //                     } else {
  //                       animals = snapshot.data ?? [];
  //                       return ListView.builder(
  //                           itemCount: animals.length,
  //                           itemBuilder: (context, index) {
  //                             final animal = animals[index];

  //                             return GestureDetector(
  //                               onTap: () {
  //                                 Navigator.push(context,
  //                                     MaterialPageRoute(builder: (context) {
  //                                   return AnimalDetailScreen(
  //                                     animal: animal,
  //                                     currentId: currentClient,
  //                                   );
  //                                 }));
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     bottom: 23, right: 7, left: 16),
  //                                 child: Stack(
  //                                   alignment: Alignment.centerLeft,
  //                                   children: [
  //                                     Material(
  //                                       borderRadius: BorderRadius.circular(20),
  //                                       elevation: 4.0,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             horizontal: 15, vertical: 15),
  //                                         child: Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.spaceBetween,
  //                                           children: [
  //                                             SizedBox(
  //                                                 width: deviceWidth * 0.4),
  //                                             Flexible(
  //                                               child: Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Row(
  //                                                     mainAxisAlignment:
  //                                                         MainAxisAlignment
  //                                                             .spaceBetween,
  //                                                     children: [
  //                                                       fieldInforPet('Name',
  //                                                           animal.namePet),
  //                                                       Icon(
  //                                                         animal.gender ==
  //                                                                 "FEMALE"
  //                                                             ? FontAwesomeIcons
  //                                                                 .venus
  //                                                             : FontAwesomeIcons
  //                                                                 .mars,
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                   const SizedBox(height: 8),
  //                                                   fieldInforPet(
  //                                                       'Breed', animal.breed),
  //                                                   const SizedBox(height: 8),
  //                                                   fieldInforPet('Age',
  //                                                       '${animal.age! * 12} months'),
  //                                                   const SizedBox(height: 8),
  //                                                   Row(
  //                                                     children: [
  //                                                       Icon(
  //                                                         FontAwesomeIcons
  //                                                             .mapMarkerAlt,
  //                                                         color:
  //                                                             Theme.of(context)
  //                                                                 .primaryColor,
  //                                                         size: 16.0,
  //                                                       ),
  //                                                       const SizedBox(
  //                                                           width: 1),
  //                                                       Text(
  //                                                         'Distance: ',
  //                                                         style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           color: Theme.of(
  //                                                                   context)
  //                                                               .primaryColor,
  //                                                           fontWeight:
  //                                                               FontWeight.w400,
  //                                                         ),
  //                                                       ),
  //                                                       Flexible(
  //                                                         child: Text(
  //                                                           // '  $distanceString KM',
  //                                                           '     KM',

  //                                                           style: TextStyle(
  //                                                             fontSize: 18,
  //                                                             color: Theme.of(
  //                                                                     context)
  //                                                                 .primaryColor,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w800,
  //                                                           ),
  //                                                           softWrap: true,
  //                                                         ),
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Stack(
  //                                       alignment: Alignment.centerLeft,
  //                                       children: [
  //                                         ClipRRect(
  //                                           borderRadius:
  //                                               BorderRadius.circular(20),
  //                                           child: Hero(
  //                                             tag: animal.namePet,
  //                                             child: Image(
  //                                               image: NetworkImage(
  //                                                   animal.images.first),
  //                                               height: 190,
  //                                               width: deviceWidth * 0.4,
  //                                               fit: BoxFit.cover,
  //                                             ),
  //                                           ),
  //                                         )
  //                                       ],
  //                                     )
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           });
  //                     }
  //                   }),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget fieldInforPet(String infor, String inforDetail) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$infor: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: inforDetail,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  Widget buildContactInfo(String info, IconData icon, String type) {
    return InkWell(
        onLongPress: () {
          _copyToClipboard(info);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied to Clipboard: $info'),
            ),
          );
        },
        onTap: () async {
          if (type == 'email') {
            launchEmail(info);
          } else if (type == 'phone') {
            makePhoneCall('tel:$info');
          } else if (type == 'address') {
            //địa chỉ map
            LatLng coordinate = await convertAddressToLatLng(info);
            //xử lý bản đồ
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => MapPage(pDestination: coordinate)),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(icon, size: 16.0),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                info,
                style: const TextStyle(
                    fontSize: 16.0, fontStyle: FontStyle.italic),
                softWrap: true,
              ),
            ),
          ],
        ));
  }

  Widget buildInfo(String info) {
    return Text(
      info,
      style: const TextStyle(fontSize: 16.0),
    );
  }

  // Hàm xử lý khi click vào ảnh avatar để hiển thị ảnh full màn hình
  void _showFullScreenImage(BuildContext context, String image) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'avatarTag',
            child: Image.network(image), // Thay đổi đường dẫn ảnh
          ),
        ),
      ),
    ));
  }

  // Hàm để mở ứng dụng email với địa chỉ được cung cấp
  void launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Không thể mở ứng dụng email';
    }
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

  // Hàm để sao chép văn bản vào clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  //lấy từ adop qua->kh code lại nữa
  // Widget buildAnimalIcon(int index) {
  //   return Padding(
  //     padding: const EdgeInsets.only(right: 30),
  //     child: Column(
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               selectedAnimalIconIndex = index;
  //             });
  //           },
  //           child: Material(
  //             color: selectedAnimalIconIndex == index
  //                 ? Theme.of(context).primaryColor
  //                 : Colors.white,
  //             elevation: 8,
  //             borderRadius: BorderRadius.circular(20),
  //             child: Padding(
  //               padding: const EdgeInsets.all(13),
  //               child: Icon(
  //                 animalIcons[index],
  //                 size: 20,
  //                 color: selectedAnimalIconIndex == index
  //                     ? Colors.white
  //                     : Theme.of(context).primaryColor,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 12,
  //         ),
  //         Text(
  //           animalTypes[index],
  //           style: TextStyle(
  //               color: Theme.of(context).primaryColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w700),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showBottomSheet(String centerId, status) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              status == 'HIDDEN'
                  ? ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Active'),
                      onTap: () async {
                        await changeStatus(context, centerId, 'ACTIVE');
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileCenterPage(
                                        centerId: centerId,
                                        petId: null,
                                      )));
                        });
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.visibility_off),
                      title: const Text('Hidden'),
                      onTap: () async {
                        changeStatus(context, centerId, 'HIDDEN');
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileCenterPage(
                                        centerId: centerId,
                                        petId: null,
                                      )));
                        });
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
