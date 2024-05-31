import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/screens/guest/widget.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/video_user.dart';
import 'package:found_adoption_application/services/followApi.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class ProfileUser extends StatefulWidget {
  final String userId;
  const ProfileUser({super.key, required this.userId});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Post>>? petStoriesPosts;
  List<Post>? posts = [];
  InfoUser? user;
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

  Future<void> _getUser() async {
    late InfoUser infoUser;
    if (widget.userId != "") {
      var temp = await getCurrentClient();
      infoUser = await getProfile(context, widget.userId);
      if (temp.role == "USER") {
        infoUser.follow = infoUser.followerUser.contains(temp.id);
      } else {
        infoUser.follow = infoUser.followerCenter.contains(temp.id);
      }
      petStoriesPosts = getAllPostPersonal(widget.userId);
    } else {
      var temp = await getCurrentClient();
      // ignore: use_build_context_synchronously
      infoUser = await getProfile(context, temp.id);
      petStoriesPosts = getAllPostPersonal(temp.id);
    }
    setState(() {
      user = infoUser;
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
                                        user!.avatar,
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
                                              user!.follower.toString(),
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
                                        Column(
                                          children: [
                                            Text(
                                              (user!.followerUser.length +
                                                      user!.followerCenter
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
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              (user!.followingCenter.length +
                                                      user!
                                                          .followingUser.length)
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
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    (currentClient.id == widget.userId ||
                                            widget.userId == "")
                                        ? const SizedBox()
                                        : onPressFollow(
                                            follow: user!.follow, id: user!.id)
                                  ],
                                )
                              ],
                            ),
                            Text(
                              '${user!.firstName} ${user!.lastName}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                user!.aboutMe,
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
                                    Text(
                                      user!.phoneNumber,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          height: 1),
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
                                    Text(
                                      user!.email,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          height: 1),
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
                                      child: Text(
                                        user!.address,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                              height: 500,
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
                                          Tab(text: 'Đã mua'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            buildPostsList(petStoriesPosts),
                                            const ListVideo(),
                                            Center(
                                              child: Text('Đã mua'),
                                            ),
                                            // TabView(recipes: listRecipe),
                                            // TabView(recipes: listRecipe),
                                            // TabView(recipes: listRecipe),
                                            // TabView(recipes: listRecipe),
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
class onPressFollow extends StatefulWidget {
  late bool follow;
  final String id;
  onPressFollow({
    super.key,
    required this.follow,
    required this.id,
  });

  @override
  State<onPressFollow> createState() => _onPressFollowState();
}

class _onPressFollowState extends State<onPressFollow> {
  late bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        await follow_unfollow(widget.id, "");
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
