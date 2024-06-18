import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/follow_model.dart';
import 'package:found_adoption_application/models/follower.dart';
import 'package:found_adoption_application/screens/guest/widget.dart';
import 'package:found_adoption_application/services/followApi.dart';

class FollowingScreen extends StatefulWidget {
  final String id;
  final dynamic currentClient;
  const FollowingScreen(
      {super.key, required this.id, required this.currentClient});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  Future<ResultFollowing>? _follower;
  List<Follower> followingUser = [];
  List<Follower> followingCenter = [];
  List<Follower> _follows = [];
  dynamic currentClient;
  Follow? follow = null;
  @override
  void initState() {
    super.initState();
    _follower = getFollowing(widget.id);
    currentClient = widget.currentClient;
    getMyFollow();
  }

  Future<void> getMyFollow() async {
    Follow follows = await getFollowCenter();
    setState(() {
      follow = follows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang theo dõi'),
      ),
      body: FutureBuilder(
          future: _follower,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            ResultFollowing result = snapshot.data as ResultFollowing;
            followingUser = result.followingUser;
            if (currentClient.role == "USER") {
              for (var element in followingUser) {
                element.isFollowed = follow!.followingUser.contains(element.id);
              }
            } else {
              for (var element in followingUser) {
                element.isFollowed = follow!.followingUser.contains(element.id);
              }
            }
            followingCenter = result.followingCenter;
            if (currentClient.role == "USER") {
              for (var element in followingCenter) {
                element.isFollowed =
                    follow!.followingCenter.contains(element.id);
              }
            } else {
              for (var element in followingCenter) {
                element.isFollowed =
                    follow!.followingCenter.contains(element.id);
              }
            }
            _follows = followingUser + followingCenter;

            return CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ListView.builder(
                        itemCount: _follows.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Text(
                                  "Người dùng theo dõi(${followingUser.length})",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Divider(
                                  height: 0.5,
                                  color: Colors.black,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 70,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    color: const Color.fromARGB(
                                        255, 173, 196, 235),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 10),
                                        Image.network(_follows[index].avatar,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            _follows[index].name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onPressFollow(
                                            follow: _follows[index].isFollowed,
                                            userId: _follows[index].id,
                                            centerId: "",
                                            me: currentClient.id ==
                                                _follows[index].id),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else if (index > 0 &&
                              index < followingUser.length) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width - 20,
                                color: const Color.fromARGB(255, 173, 196, 235),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.network(_follows[index].avatar,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        _follows[index].name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    onPressFollow(
                                        follow: _follows[index].isFollowed,
                                        userId: _follows[index].id,
                                        centerId: "",
                                        me: currentClient.id ==
                                            _follows[index].id),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          } else if (index == followingUser.length) {
                            return Column(
                              children: [
                                Text(
                                  "Trung tâm theo dõi(${followingCenter.length})",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Divider(
                                  height: 0.5,
                                  color: Colors.black,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 70,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    color: const Color.fromARGB(
                                        255, 173, 196, 235),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 10),
                                        Image.network(_follows[index].avatar,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            _follows[index].name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onPressFollow(
                                            follow: _follows[index].isFollowed,
                                            centerId: _follows[index].id,
                                            userId: "",
                                            me: currentClient.id ==
                                                _follows[index].id),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width - 20,
                                color: const Color.fromARGB(255, 173, 196, 235),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.network(_follows[index].avatar,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        _follows[index].name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    onPressFollow(
                                        follow: _follows[index].isFollowed,
                                        centerId: _follows[index].id,
                                        userId: "",
                                        me: currentClient.id ==
                                            _follows[index].id),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]);
          }),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class onPressFollow extends StatefulWidget {
  late bool follow;
  final String userId;
  final String centerId;
  final bool me;
  onPressFollow({
    super.key,
    required this.follow,
    required this.userId,
    required this.centerId,
    required this.me,
  });

  @override
  State<onPressFollow> createState() => _onPressFollowState();
}

// ignore: camel_case_types
class _onPressFollowState extends State<onPressFollow> {
  late bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !widget.me
        ? GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              await follow_unfollow(widget.userId, widget.centerId);
              setState(() {
                widget.follow = !widget.follow;
              });
              setState(() {
                isLoading = false;
              });
            },
            child: Container(
              width: 130,
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
          )
        : const SizedBox(
            width: 130,
            height: 30,
          );
  }
}
