import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/screens/change_password.dart';
import 'package:found_adoption_application/screens/map_page.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final userId;
  ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Post>>? petStoriesPosts;
  late Future<InfoUser>? userFuture;
  var currentClient;
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    petStoriesPosts = getAllPostPersonal(widget.userId);
    userFuture = getProfile(context, widget.userId);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MenuFrameUser(
                              userId: currentClient.id,
                            )),
                  );
                } else if (currentClient.role == 'CENTER') {
                  Navigator.push(
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
          title: Text(
            'Profile',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     // Sử dụng TypewriterAnimatedTextKit để tạo hiệu ứng chữ chạy
          //     TypewriterAnimatedTextKit(
          //       speed: Duration(milliseconds: 200),
          //       totalRepeatCount:
          //           1, // Số lần lặp (1 lần để chạy từ đầu đến cuối)
          //       text: ['Profile'],
          //       textStyle: TextStyle(
          //         color: Theme.of(context).primaryColor,
          //         fontSize: 30.0,
          //         fontWeight: FontWeight.bold,
          //         letterSpacing: 2.0,
          //       ),
          //     ),
          //   ],
        ),
        body: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<InfoUser>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still loading, show a loading indicator
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // If there is an error fetching data, show an error message
                    return const Center(child: Text('User not found.'));
                  } else {
                    // If data is successfully fetched, display the form
                    InfoUser user = snapshot.data!;
                    if (user.status == 'HIDDEN') {
                      if (currentClient.id != widget.userId) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility_off,
                                size: 100,
                                color: Colors.grey,
                              ),
                              Text(
                                'This user is hidden',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return SingleChildScrollView(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ảnh đại diện
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Avatar
                                  InkWell(
                                    onTap: () {
                                      _showFullScreenImage(
                                          context, user.avatar);
                                    },
                                    child: Hero(
                                      tag: 'avatarTag',
                                      child: CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage:
                                            NetworkImage('${user.avatar}'),
                                      ),
                                    ),
                                  ),
                                  // Nút Follow và Edit Profile
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          notification(
                                              "Feature under development",
                                              false);
                                        },
                                        icon: Icon(Icons.person_add,
                                            color: Colors.white),
                                        label: Text('Follow'),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      currentClient.id == widget.userId
                                          ? PopupMenuButton<int>(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Container(
                                                    width: 175,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditProfileScreen()));
                                                      },
                                                      icon: Icon(Icons.edit,
                                                          color: Colors.white),
                                                      label:
                                                          Text('Edit profile'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors.white, backgroundColor: Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                //Update Password
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Container(
                                                    width: 175,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UpdatePasswordScreen()));
                                                      },
                                                      icon: Icon(Icons.password,
                                                          color: Colors.white),
                                                      label: Text(
                                                          'Change Password'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors.white, backgroundColor: Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Container(
                                                    width: 175,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        _showBottomSheet(
                                                            user.id,
                                                            user.status);
                                                      },
                                                      icon: Icon(
                                                          Icons.change_circle,
                                                          color: Colors.white),
                                                      label:
                                                          Text('Change status'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor: Colors.white, backgroundColor: Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                // Handle your logic based on selected value
                                              },
                                              icon: Icon(Icons.more_vert,
                                                  color: Colors.grey),
                                            )
                                          : SizedBox(width: .0),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              // Status icon
                              // Họ và Tên
                              Row(
                                children: [
                                  // User's name
                                  Text(
                                    '${user.firstName} ${user.lastName} ',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Status icon
                                  Icon(
                                    user.status == 'ACTIVE'
                                        ? Icons.check_circle
                                        : Icons.visibility_off,
                                    color: user.status == 'ACTIVE'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),

                              // Contact me
                              buildSectionHeader('Contact me', Icons.mail),
                              buildContactInfo(
                                  user.phoneNumber, Icons.phone, 'phone'),
                              buildContactInfo(
                                  user.email, Icons.email, 'email'),
                              buildContactInfo(
                                  user.address,
                                  const IconData(0xe3ab,
                                      fontFamily: 'MaterialIcons'),
                                  'address'),
                              SizedBox(height: 16.0),

                              // About me
                              buildSectionHeader('About me', Icons.info),
                              buildInfo(user.aboutMe),
                              SizedBox(height: 16.0),

                              // Experience
                              buildSectionHeader('Experience', Icons.work),
                              buildInfo(user.experience
                                  ? "Has been Experience"
                                  : "No Experience"),
                              SizedBox(height: 16.0),

                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: const Color.fromARGB(255, 176, 175, 175),
                                margin: EdgeInsets.symmetric(vertical: 16.0),
                              ),

                              // List các bài viết đã đăng
                              buildSectionHeader(
                                  'Article posted', Icons.library_books),
                              // Dùng ListView để hiển thị danh sách các bài viết
                              DefaultTabController(
                                  length: 1,
                                  child: Column(children: [
                                    // TabBar để chọn giữa "Pet Stories" và "Pet Adoption"
                                    TabBar(
                                      labelColor:
                                          Theme.of(context).primaryColor,
                                      tabs: [
                                        Tab(text: 'Pet Stories'),
                                      ],
                                    ),
                                    // TabBarView để hiển thị nội dung tương ứng với từng tab
                                    SizedBox(
                                      height:
                                          500, // Thay đổi kích thước này tùy theo nhu cầu của bạn
                                      child: TabBarView(
                                        children: [
                                          // Nội dung cho tab "Pet Stories"
                                          buildPostsList(petStoriesPosts!),
                                        ],
                                      ),
                                    )
                                  ]))
                            ]));
                  }
                })));
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      petStoriesPosts = getAllPostPersonal(widget.userId);
      userFuture = getProfile(context, widget.userId);
    });
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
            if (postList!.isNotEmpty) {
              return ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: postList[index]),
              );
            } else {
              // Xử lý trường hợp postList là null
              return Scaffold(
                body: Center(
                  child: Icon(
                    Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                    size: 48.0,
                    color: Colors.grey,
                  ),
                ),
              );
            }
          }
        });
  }

  Widget buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: Theme.of(context).primaryColor),
        SizedBox(width: 8.0),
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
            makePhoneCall('tel:${info}');
          } else if (type == 'address') {
            LatLng coordinate = await convertAddressToLatLng(info);
            //xử lý bản đồ
            Navigator.push(
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
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                info,
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                softWrap: true,
              ),
            ),
          ],
        ));
  }

  Widget buildInfo(String info) {
    return Text(
      info,
      style: TextStyle(fontSize: 16.0),
    );
  }

  // Hàm xử lý khi click vào ảnh avatar để hiển thị ảnh full màn hình
  void _showFullScreenImage(BuildContext context, image) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'avatarTag',
            child: Image.network('${image}'),
          ),
        ),
      ),
    ));
  }

  // Hàm để mở ứng dụng email với địa chỉ được cung cấp
  void launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Không thể mở ứng dụng email';
    }
  }

  void makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Không thể gọi điện thoại';
    }
  }

  // Hàm để sao chép văn bản vào clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _showBottomSheet(String userId, status) {
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
                        await changeStatus(context, userId, 'ACTIVE');
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userId: userId,
                                      )));
                        });
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.visibility_off),
                      title: const Text('Hidden'),
                      onTap: () async {
                        changeStatus(context, userId, 'HIDDEN');
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userId: userId,
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
