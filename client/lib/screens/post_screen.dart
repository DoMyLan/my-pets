import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/screens/new_post_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  const PostScreen({super.key, required this.postId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<Post>? post;

  @override
  void initState() {
    super.initState();
    post = getOnePost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Pet stories',
            style:
                TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0), fontSize: 23),
          ),
          leading: IconButton(
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
            icon: const Icon(
              FontAwesomeIcons.bars,
              size: 25,
              color: Color.fromRGBO(48, 96, 96, 1.0),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewPostScreen()));
              },
              icon: const Icon(
                Icons.add_circle,
                size: 30,
                color: Color.fromRGBO(48, 96, 96, 1.0),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Please try again later'));
              } else {
                Post? post = snapshot.data;

                if (post != null) {
                  return PostCard(snap: post);
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
            },
          ),
        ));
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      post = getOnePost(widget.postId);
    });
  }
}
