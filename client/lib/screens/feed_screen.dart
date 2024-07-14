import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/custom_widget/video_widget.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/short_video.dart';
import 'package:found_adoption_application/screens/new_post_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
// ignore: library_prefixes
import 'package:found_adoption_application/screens/add_short_video.dart'
    as addShortVideo;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<Post> allPosts = [];
  List<Post> visiblePosts = [];

  List<ShortVideo> allVideos = [];
  List<ShortVideo> visibleVideos = [];

  int itemsPerPage = 10;
  int currentPage = 1;
  int countScroll = 0;
  int totalPages = 1;

  int itemsPerPageVideo = 10;
  int currentPageVideo = 1;
  int countScrollVideo = 0;
  int totalPagesVideo = 1;

  bool isLoading = true;

  bool isLoadingVideo = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPosts();
    _loadPostsVideo();
  }

  @override
  void dispose() {
    // Cancel any ongoing operations here
    super.dispose();
  }

  Future<void> _loadPostsVideo() async {
    try {
      setState(() {
        isLoadingVideo = true;
      });
      setState(() {
        _loadVisiblePostsVideo();
      });
    } catch (e) {
      setState(() {
        isLoadingVideo = false;
      });
    }
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

  Future<void> _loadVisiblePostsVideo() async {
    VideoResult postReturn =
        await getShortVideo(currentPageVideo, itemsPerPageVideo);
    List<ShortVideo> newPosts = postReturn.posts;
    totalPagesVideo = postReturn.totalPages;
    if (mounted) {
      setState(() {
        visibleVideos.addAll(newPosts);
        countScrollVideo = 0;
      });
    }

    if (mounted) {
      setState(() {
        isLoadingVideo = false;
      });
    }
  }

  Future<void> _loadVisiblePosts() async {
    PostResult postReturn = await getAllPost(currentPage, itemsPerPage);
    List<Post> newPosts = postReturn.posts;
    totalPages = postReturn.totalPages;
    if (mounted) {
      setState(() {
        visiblePosts.addAll(newPosts);
        countScroll = 0;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      visiblePosts.clear();
      currentPage = 1;
      _loadPosts();
      visibleVideos.clear();
      currentPageVideo = 1;
      _loadPostsVideo();
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

  Future<void> _loadMoreItemsVideo() async {
    if (!isLoadingVideo) {
      setState(() {
        currentPageVideo++;
        _loadVisiblePostsVideo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bài viết'),
            Tab(text: 'Video ngắn'),
          ],
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Bài viết về thú cưng',
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
            onPressed: _refresh,
            icon: const Icon(
              Icons.refresh,
              size: 30,
              color: Color.fromRGBO(48, 96, 96, 1.0),
            ),
          ),
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        RefreshIndicator(
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
        RefreshIndicator(
          onRefresh: _refresh,
          child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  countScrollVideo++;
                  if (countScroll == 1) {
                    if (currentPageVideo <= totalPagesVideo) {
                      _loadMoreItemsVideo();
                    }
                  }
                }
                return true;
              },
              child: PageView.builder(
                itemCount: visibleVideos.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  if (!isLoadingVideo) {
                    return VideoApp(
                      videoPost: visibleVideos[index],
                      back: false,
                    );
                  } else if (isLoadingVideo) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(); // Hiển thị một widget trống khi không có thêm dữ liệu
                  }
                },
              )),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.video_call),
                      title: const Text('Video'),
                      onTap: () {
                        // Đóng bottom sheet
                        Navigator.pop(context);
                        // Logic để chuyển đến màn hình tạo Video
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => addShortVideo
                                .ShortVideo(), // Đã có sẵn trong comment của bạn
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: const Text('Bài viết'),
                      onTap: () {
                        // Đóng bottom sheet
                        Navigator.pop(context);
                        // Logic để chuyển đến màn hình tạo Bài viết
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NewPostScreen(), // Đã có sẵn trong comment của bạn
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
