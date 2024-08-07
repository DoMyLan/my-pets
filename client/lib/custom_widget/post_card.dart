import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/like_model.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/comment_screen.dart';
import 'package:found_adoption_application/screens/edit_post_screen.dart';
import 'package:found_adoption_application/screens/like_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center_new.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user_new.dart';
import 'package:found_adoption_application/services/post/like_post_api.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socket_io_client/socket_io_client.dart' as io;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post clientPost;
  late int quantityLike = 0;
  late bool liked = false;
  late String selectedOption = '';
  late io.Socket socket;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    clientPost = widget.snap!;
    getLiked();

    // Khởi tạo kết nối Socket.IO
    socket = io.io(
        'http://socket-found-adoption-dangvantuan.koyeb.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // socket.on("getOnlineUsers", (data) {
    //   if (data['userId'] == clientPost.userId?.id ||
    //       data['userId'] == clientPost.petCenterId?.id) {
    //     setState(() {
    //       isOnline = true;
    //     });
    //   }
    // });
  }

  Future<void> getLiked() async {
    List<Like>? likes = await getLike(context, clientPost.id);
    var currentClient = await getCurrentClient();
    if (mounted) {
      setState(() {
        quantityLike = likes.length;
      });
    }
    for (var element in likes) {
      if (element.centerId?.id == currentClient!.id ||
          element.userId?.id == currentClient!.id) {
        if (mounted) {
          setState(() {
            liked = true;
          });
        }
      }
    }
  }

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // final int maxLines = 3;
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.only(left: 0, top: 0, bottom: 1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                const SizedBox(
                  height: 5,
                ),

                //Chỉ thêm mỗi chỗ này thôi à
                GestureDetector(
                  onTap: () {
                    if (clientPost.userId != null) {
                      // Nếu là loại "center", chuyển đến ProfileCenterPage
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileUser(
                                  userId: clientPost.userId!
                                      .id) // Thay thế bằng tên lớp tương ứng
                              ));
                    } else {
                      // Ngược lại, chuyển đến ProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileCenter(
                              centerId: clientPost.petCenterId!.id),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          clientPost.userId != null
                              ? clientPost.userId!.avatar
                              : clientPost.petCenterId!.avatar,
                        ),
                      ),
                      isOnline
                          ? Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: const BoxDecoration(
                                  color: Colors.green, // Green color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      clientPost.userId != null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileUser(
                                      userId: clientPost.userId!.id)))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileCenter(
                                    centerId: clientPost.petCenterId!.id),
                              ),
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                clientPost.userId != null
                                    ? '${clientPost.userId!.firstName} ${clientPost.userId!.lastName}'
                                    : clientPost.petCenterId!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              clientPost.userId == null
                                  ? const Icon(FontAwesomeIcons.paw,
                                      size: 12, color: Colors.grey)
                                  : const Icon(FontAwesomeIcons.user,
                                      size: 12, color: Colors.grey)
                            ],
                          ),

                          //Thời gian đăng bài
                          Text(
                            DateFormat.yMMMMd()
                                .add_Hms()
                                .format(clientPost.createdAt),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${timeago.format(clientPost.createdAt.subtract(const Duration(seconds: 10)), locale: 'en_short')} ago',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var currentClient = await getCurrentClient();
                      // ignore: use_build_context_synchronously
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            children: ((currentClient.id ==
                                            clientPost.userId?.id ||
                                        currentClient.id ==
                                            clientPost.petCenterId?.id)
                                    ? [
                                        {'text': 'Sửa', 'icon': Icons.edit},
                                        {
                                          'text': 'Xóa',
                                          'icon': Icons.delete
                                        },
                                        {
                                          'text': 'Cập nhật trạng thái',
                                          'icon': Icons.refresh
                                        },
                                      ]
                                    : [
                                        {'text': 'Báo cáo', 'icon': Icons.report}
                                      ])
                                .map(
                                  (item) => InkWell(
                                    onTap: () {
                                      if (item['text'] == 'Cập nhật trạng thái') {
                                        _showBottomSheet(
                                            clientPost.id, clientPost);
                                      } else if (item['text'] == 'Sửa') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPostScreen(
                                                        onePost: clientPost)));
                                      } else if (item['text'] == 'Xóa') {
                                        _showDeleteConfirmationDialog(
                                            clientPost.id);
                                      } else if (item['text'] == 'Báo cáo') {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.public_off),
                                                  title: const Text(
                                                      'Vi phạm tiêu chuẩn cộng đồng'),
                                                  onTap: () async {
                                                    Loading(context);
                                                    await reportPost(
                                                        clientPost.id,
                                                        'POST',
                                                        'Vi phạm tiêu chuẩn cộng đồng');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.error_outline),
                                                  title: const Text(
                                                      'Ngôn ngữ gây hiểu lầm'),
                                                  onTap: () async {
                                                    Loading(context);
                                                    await reportPost(
                                                        clientPost.id,
                                                        'POST',
                                                        'Ngôn ngữ gây hiểu lầm');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.warning),
                                                  title: const Text('Bạo lực'),
                                                  onTap: () async {
                                                    Loading(context);
                                                    await reportPost(
                                                        clientPost.id,
                                                        'POST',
                                                        'Bạo lực');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.block),
                                                  title: const Text(
                                                      'Nội dung không phù hợp'),
                                                  onTap: () async {
                                                    Loading(context);
                                                    await reportPost(
                                                        clientPost.id,
                                                        'POST',
                                                        'Nội dung không phù hợp');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons
                                                      .difference_outlined),
                                                  title: const Text('Khác'),
                                                  onTap: () {
                                                    // Open dialog to enter custom reason
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        TextEditingController
                                                            reasonController =
                                                            TextEditingController();
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Nhập lý do'),
                                                          content: TextField(
                                                            controller:
                                                                reasonController,
                                                            onChanged: (value) {
                                                              // Handle value from text field
                                                            },
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'Gửi báo cáo'),
                                                              onPressed:
                                                                  () async {
                                                                Loading(
                                                                    context);

                                                                await reportPost(
                                                                    clientPost
                                                                        .id,
                                                                    'POST',
                                                                    reasonController
                                                                        .text
                                                                        .toString());
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      // Add other logic for handling other options
                                    },
                                    child: SizedBox(
                                      height: 70,
                                      child: ListTile(
                                        title: Text(
                                          item['text'] as String,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        leading: Icon(
                                          item['icon'] as IconData?,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),

          if (clientPost.images != null && clientPost.images!.isNotEmpty)
            clientPost.images!.length == 1
                ? Image.network(
                    clientPost.images!.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      // Return an Icon widget when there's an error
                      return const Icon(Icons.image_not_supported,
                          color: Colors.red);
                    },
                  )
                : _slider(clientPost.images)
          else
            const SizedBox(),

          clientPost.petId != null
              ? Container(
                  color: Colors.grey.shade100,
                  width: MediaQuery.of(context).size.width - 20,
                  height: 70,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                        image: NetworkImage(
                                            clientPost.petId!.images[0]),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${clientPost.petId!.namePet} - ",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(clientPost.petId!.breed,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Text(
                                            "${int.parse(clientPost.petId!.price) - clientPost.petId!.reducePrice > 0 ? int.parse(clientPost.petId!.price) - clientPost.petId!.reducePrice : "Miễn phí"}đ",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        dynamic currentClient =
                                            await getCurrentClient();
                                        Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnimalDetailScreen(
                                                      petId:
                                                          clientPost.petId!.id,
                                                      currentId: currentClient,
                                                    )));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: const Text(
                                          'Xem chi tiết',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(width: 10),
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     dynamic currentClient =
                                    //         await getCurrentClient();
                                            
                                    //     Navigator.push(
                                    //         // ignore: use_build_context_synchronously
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 PaymentScreen(
                                    //                   pet: clientPost.petId,
                                    //                   currentClient:
                                    //                       currentClient,
                                    //                 )));
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.symmetric(
                                    //         horizontal: 10, vertical: 5),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.red[400],
                                    //       borderRadius:
                                    //           BorderRadius.circular(20.0),
                                    //     ),
                                    //     child: const Text(
                                    //       'Mua ngay',
                                    //       style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontSize: 12),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(width: 10),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(),

          //LIKE+COMMENT SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    if (!liked) {
                      setState(() {
                        quantityLike += 1;
                        liked = true;
                      });
                    } else {
                      setState(() {
                        quantityLike -= 1;
                        liked = false;
                      });
                    }
                    await like(context, clientPost.id);
                  },
                  icon: liked == false
                      ? const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                  iconSize: 29.0,
                ),
              ),
              IconButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommentScreen(postId: clientPost.id)));
                },
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.red),
                iconSize: 29.0,
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.red,
                  ),
                  iconSize: 29.0,
                ),
              ),
            ],
          ),

          //DESCRIPTION & NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LikeScreen(postId: clientPost.id)));
                  },
                  child: Text(
                    '$quantityLike likes',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 146, 144, 144)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(postId: clientPost.id)));
                  },
                  child: Text(
                    'View all ${clientPost.comments!.length} comments',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 146, 144, 144),
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: clientPost.userId != null
                                ? '${clientPost.userId!.firstName} ${clientPost.userId!.lastName}'
                                : clientPost.petCenterId!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // TextSpan(
                          //   text: '  ${clientPost.content}',
                          //   style:
                          //       const TextStyle(fontWeight: FontWeight.normal),
                          // )

                          TextSpan(
                            text: isExpanded
                                ? '  ${clientPost.content}'
                                : '  ${clientPost.content.substring(0, clientPost.content.length < 100 ? clientPost.content.length : 100)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          if (clientPost.content.length > 100)
                            TextSpan(
                              text: isExpanded ? ' Show less' : '... See more',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                            ),
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(List? imageList) {
    return Stack(
      children: [
        CarouselSlider(
          items: imageList!
              .map(
                (item) => Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Return an Icon widget when there's an error
                    return const Icon(Icons.image_not_supported,
                        color: Colors.red);
                  },
                ),
              )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: 20 / 20,
            viewportFraction: 1,

            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        //cấu hình nút chạy ảnh
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 17 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? Colors.red : Colors.teal),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(String postId, var clientPost) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              (clientPost.status == 'HIDDEN')
                  ? ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Active'),
                      onTap: () async {
                        Loading(context);
                        var message = await changeStatusPost(postId, 'ACTIVE');

                        setState(() {
                          notification(message, false);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.visibility_off),
                      title: const Text('Hidden'),
                      onTap: () async {
                        Loading(context);
                        var message = await changeStatusPost(postId, 'HIDDEN');
                        setState(() {
                          notification(message, false);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(String postId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this post?'),
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
                var message = await deleteOnePost(postId);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                notification(message, false);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
