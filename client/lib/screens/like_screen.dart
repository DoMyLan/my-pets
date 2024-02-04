import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/like_model.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/post/like_post_api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

class LikeScreen extends StatefulWidget {
  final postId;
  LikeScreen({super.key, required this.postId});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Future<List<Like>>? likeFuture;

  @override
  void initState() {
    super.initState();
    likeFuture = getLike(context, widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Likes',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
            future: likeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                List<Like> likes = snapshot.data as List<Like>;

                return ListView.builder(
                    itemCount: likes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              leading: GestureDetector(
                                onTap: () async {
                                  likes[index].userId != null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                  userId:
                                                      likes[index].userId!.id)))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileCenterPage(
                                                    centerId: likes[index]
                                                        .centerId!
                                                        .id),
                                          ),
                                        );
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4, color: Colors.white),

                                        //hiệu ứng bóng đổ
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.1))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CommentBox.commentImageParser(
                                            imageURLorPath: likes[index]
                                                        .userId !=
                                                    null
                                                ? '${likes[index].userId!.avatar}'
                                                : '${likes[index].centerId!.avatar}',
                                          ),
                                        )),
                                  ),
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SizedBox(
                                      height: 30,
                                      width: 45,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              title: Container(
                                margin: EdgeInsets.only(
                                    left: 0.0), // Adjust the value as needed

                                child: Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            likes[index].userId != null
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
                                                                userId:
                                                                    likes[index]
                                                                        .userId!
                                                                        .id)))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileCenterPage(
                                                              centerId:
                                                                  likes[index]
                                                                      .centerId!
                                                                      .id),
                                                    ),
                                                  );
                                          },
                                          child: Text(
                                            likes[index].userId != null
                                                ? '${likes[index].userId!.firstName} ${likes[index].userId!.lastName}'
                                                : '${likes[index].centerId!.name}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )),
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
                                          primary:
                                              Theme.of(context).primaryColor,
                                          onPrimary: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              height: 1,
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return SizedBox.shrink();
              }
            }));
  }
}
