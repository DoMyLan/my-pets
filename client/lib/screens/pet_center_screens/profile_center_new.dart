import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/call_login.dart';
import 'package:found_adoption_application/screens/change_password.dart';
import 'package:found_adoption_application/screens/guest_login/widget.dart';
import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';
import 'package:found_adoption_application/screens/user_screens/follower_screen.dart';
import 'package:found_adoption_application/screens/user_screens/following_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/video_user.dart';
import 'package:found_adoption_application/services/followApi.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCenter extends StatefulWidget {
  final String centerId;
  const ProfileCenter({super.key, required this.centerId});

  @override
  State<ProfileCenter> createState() => _ProfileCenterState();
}

class _ProfileCenterState extends State<ProfileCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Post>>? petStoriesPosts;
  List<Post>? posts = [];
  InfoCenter? center;
  dynamic currentClient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isLoading = true;

    getClient();
    _getUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Logic để chuyển đến màn hình chỉnh sửa trang cá nhân
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProfileCenterScreen()), // Thay thế EditProfileScreen bằng màn hình chỉnh sửa trang cá nhân của bạn
        );
        break;
      case 1:
        // Logic để chuyển đến màn hình đổi mật khẩu
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UpdatePasswordScreen()), // Thay thế ChangePasswordScreen bằng màn hình đổi mật khẩu của bạn
        );
        break;
    }
  }

  Future<void> _getUser() async {
    late InfoCenter infoCenter;
    if (widget.centerId != "") {
      var temp = await getCurrentClient();
      infoCenter = await getProfileCenter(context, widget.centerId);
      if (temp == null) {
        infoCenter.follow = false;
      } else {
        if (temp.role == "USER") {
          infoCenter.follow = infoCenter.followerUser.contains(temp.id);
        } else {
          infoCenter.follow = infoCenter.followerCenter.contains(temp.id);
        }
      }
      petStoriesPosts = getAllPostPersonal(widget.centerId);
    } else {
      var temp = await getCurrentClient();
      // ignore: use_build_context_synchronously
      infoCenter = await getProfileCenter(context, temp.id);
      petStoriesPosts = getAllPostPersonal(temp.id);
    }
    setState(() {
      center = infoCenter;
      isLoading = false;
    });
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  // Future<void> _handleRefresh() async {
  //   await Future.delayed(const Duration(seconds: 2));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            leading: IconButton(
              onPressed: () async {
                var currentClient = await getCurrentClient();

                if (currentClient != null) {
                  if (currentClient.role == 'USER') {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuFrameUser(
                          userId: currentClient.id,
                        ),
                      ),
                    );
                  } else if (currentClient.role == 'CENTER') {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      // ignore: use_build_context_synchronously
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
        ),
        body: RefreshIndicator(
          onRefresh: _getUser,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: Image.network(
                                        center!.avatar,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              center!.follower.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800]),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              'Bài viết',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  height: 1.5),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowerScreen(
                                                  id: center!.id,
                                                  currentClient: currentClient,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                (center!.followerUser.length +
                                                        center!.followerCenter
                                                            .length)
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800]),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Theo dõi',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    height: 1.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowingScreen(
                                                  id: center!.id,
                                                  currentClient: currentClient,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                (center!.followingCenter
                                                            .length +
                                                        center!.followingUser
                                                            .length)
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800]),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Đang theo dõi',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    height: 1.5),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    currentClient != null
                                        ? (currentClient.id ==
                                                    widget.centerId ||
                                                widget.centerId == "")
                                            ? PopupMenuButton<int>(
                                                onSelected: (item) =>
                                                    onSelected(context, item),
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text(
                                                        'Chỉnh sửa trang cá nhân'),
                                                  ),
                                                  const PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Text('Đổi mật khẩu'),
                                                  ),
                                                ],
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      140,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.teal),
                                                  child: !isLoading
                                                      ? const Center(
                                                          child: Text(
                                                            "Cập nhật thông tin",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      : const OnPressedButton(
                                                          size: 13,
                                                          strokeWidth: 2.0,
                                                        ),
                                                ),
                                              )
                                            : OnPressFollow(
                                                follow: center!.follow,
                                                id: center!.id)
                                        : const SizedBox()
                                  ],
                                )
                              ],
                            ),
                            Text(
                              center!.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                center!.aboutMe,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    height: 1.5),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chi tiết cá nhân',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800]),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: Colors.grey[800],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Số điện thoại: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          height: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        makePhoneCall(center!.phoneNumber);
                                      },
                                      child: Text(
                                        center!.phoneNumber,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontStyle: FontStyle.italic,
                                            height: 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.grey[800],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Email: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          height: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        launchEmail(center!.email);
                                      },
                                      child: Text(
                                        center!.email,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blue,
                                            height: 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey[800],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Địa chỉ: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          height: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: TextButton(
                                        onPressed: () =>
                                            MapsLauncher.launchCoordinates(
                                                double.parse(center!.location.latitude),
                                                double.parse(center!.location.longitude),
                                                center!.name),
                                        
                                        child: Text(
                                          center!.address,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontStyle: FontStyle.italic,
                                            height: 1,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 700,
                              width: MediaQuery.of(context).size.width,
                              child: SafeArea(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TabBar(
                                        isScrollable: true,
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        labelPadding: const EdgeInsets.only(
                                            left: 0, right: 14),
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                        controller: _tabController,
                                        labelColor: Colors.black,
                                        indicator: UnderlineTabIndicator(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                width: 2,
                                                style: BorderStyle.solid,
                                                color: Colors.grey),
                                            insets: EdgeInsets.zero),
                                        unselectedLabelColor: Colors.grey,
                                        tabs: const <Widget>[
                                          Tab(text: 'Bài viết'),
                                          Tab(text: 'Video'),
                                          Tab(text: 'Thú cưng'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            currentClient == null
                                                ? const CallLogin()
                                                : buildPostsList(
                                                    petStoriesPosts),
                                            currentClient == null
                                                ? const CallLogin()
                                                : ListVideo(id: center!.id),
                                            currentClient == null
                                                ? const CallLogin()
                                                : AdoptionScreen(
                                                    centerId: center!.id)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}

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
              itemBuilder: (context, index) => PostCard(snap: postList[index]),
            );
          } else {
            // Xử lý trường hợp postList là null
            return const Scaffold(
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

// ignore: must_be_immutable
class OnPressFollow extends StatefulWidget {
  late bool follow;
  final String id;
  OnPressFollow({
    super.key,
    required this.follow,
    required this.id,
  });

  @override
  State<OnPressFollow> createState() => _onPressFollowState();
}

class _onPressFollowState extends State<OnPressFollow> {
  late bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        await follow_unfollow("", widget.id);
        setState(() {
          widget.follow = !widget.follow;
        });
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 140,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.follow ? Colors.grey : Colors.teal),
        child: !isLoading
            ? Center(
                child: Text(
                  widget.follow ? "Đang theo dõi" : "Theo dõi",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )
            : const OnPressedButton(
                size: 13,
                strokeWidth: 2.0,
              ),
      ),
    );
  }
}
