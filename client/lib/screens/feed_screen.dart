import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/screens/new_post_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> allPosts = [];
  List<Post> visiblePosts = [];

  int itemsPerPage = 10;
  int currentPage = 1;
  int countScroll = 0;
  int totalPages = 1;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
      });
      setState(() {
        _loadVisiblePosts();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadVisiblePosts() async {
    PostResult postReturn = await getAllPost(currentPage, itemsPerPage);
    List<Post> newPosts = postReturn.posts;
    totalPages = postReturn.totalPages;
    setState(() {
      visiblePosts.addAll(newPosts);
      countScroll = 0;
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      visiblePosts.clear();
      currentPage = 1;
      _loadPosts();
    });
  }

  Future<void> _loadMoreItems() async {
    if (!isLoading) {
      setState(() {
        currentPage++;
        _loadVisiblePosts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Pet stories',
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
                // ignore: use_build_context_synchronously
                Navigator.push(
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(),
                ),
              );
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              countScroll++;
              if (countScroll == 1) {
                if (currentPage <= totalPages) {
                  _loadMoreItems();
                }
              }
            }
            return true;
          },
          child: ListView.builder(
            itemCount: visiblePosts.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (!isLoading) {
                return PostCard(snap: visiblePosts[index]);
              } else if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(); // Hiển thị một widget trống khi không có thêm dữ liệu
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Reload',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// RefreshIndicator(
//           onRefresh: _refresh,
//           child: FutureBuilder<PostResult>(
//             future: getAllPost(1, 10),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasError) {
//                 return const Center(child: Text('Please try again later'));
//               } else {
//                 List<Post>? postList = snapshot.data!.posts;

//                 if (postList != null) {
//                   return ListView.builder(
//                     itemCount: postList.length,
//                     itemBuilder: (context, index) =>
//                         PostCard(snap: postList[index]),
//                   );
//                 } else {
//                   // Xử lý trường hợp postList là null
//                   return const Scaffold(
//                     body: Center(
//                       child: Icon(
//                         Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
//                         size: 48.0,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   );
//                 }
//               }
//             },
//           ),
//         ));