import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/models/pet_center.dart'
    as center_comment;
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart' as user_comment;
import 'package:found_adoption_application/models/user.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/post/comment.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CommentScreen extends StatefulWidget {
  final postId;
  CommentScreen({super.key, required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  late Future<List<Comment>> commentsFuture;
  late io.Socket socket;
  late String avatarURL = '';
  // List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchAvatarURL();
    commentsFuture = getComment(widget.postId);

    // Khởi tạo kết nối Socket.IO
    socket = io.io(
        'http://socket-found-adoption-dangvantuan.koyeb.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on("comment", (data) {
      _handleComment(data);
    });

    // Gọi hàm getComment trong initState để lấy dữ liệu khi widget được tạo
  }

  Future<void> _fetchAvatarURL() async {
    // Sử dụng await ở đây để lấy giá trị từ HiveBox
    var currentClient = await getCurrentClient();
    avatarURL = currentClient.avatar;

    if (currentClient != null) {
      setState(() {
        avatarURL = currentClient.avatar;
      });
    }
  }

  void _handleComment(data) async {
    late Comment newCommentRe;

    // Extract userId data from the map
    var userIdData = data['userId'];

    // Create a User object from the userIdData
    User? userId = userIdData['firstName'] != ''
        ? User(
            id: userIdData['_id'],
            firstName: userIdData['firstName'],
            lastName: userIdData['lastName'],
            avatar: userIdData['avatar'],
            address: userIdData['address'],
            phoneNumber: userIdData['phoneNumber'],
            email: userIdData['email'],
            status: userIdData['status'])
        : null;

    // Extract centerId data from the map
    var centerIdData = data['centerId'];

    // Create a PetCenter object from the centerIdData
    PetCenter? centerId = centerIdData['name'] != ''
        ? PetCenter(
            id: centerIdData['_id'],
            name: centerIdData['name'],
            avatar: centerIdData['avatar'],
            address: centerIdData['address'],
            phoneNumber: centerIdData['phoneNumber'],
            email: userIdData['email'],
            status: userIdData['status'])
        : null;

    newCommentRe = Comment(
      id: data['_id'],
      userId: userId,
      centerId: centerId,
      commentId: '',
      content: data['content'],
      createdAt: DateTime.now(),
    );

    // Thêm comment mới vào danh sách commentsFuture
    // comments = [...comments, newCommentRe];

    setState(() {
      commentsFuture.then((comments) {
        comments.add(newCommentRe);
        return comments;
      });
    });
  }

  // //comment
  Widget commentChild(List<Comment> comments) {
    // if (comments.isEmpty) {
    //   return Center(
    //     child: Text('No comments yet.'),
    //   );
    // }
    return FutureBuilder(
        future: commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Post not found.')
                // Text('Error: ${snapshot.error}'),
                );
          } else if (snapshot.hasData) {
            comments = snapshot.data as List<Comment>;
            return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 4.0, 2.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onLongPress: () {
                            _showDeleteConfirmationDialog(
                                widget.postId, comments[index].id);
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: GestureDetector(
                            onTap: () async {
                              comments[index].userId != null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              userId:
                                                  comments[index].userId!.id)))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileCenterPage(
                                            centerId:
                                                comments[index].centerId!.id),
                                      ),
                                    );
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: CommentBox.commentImageParser(
                                  // imageURLorPath: data[i]['pic'],
                                  imageURLorPath: comments[index].userId != null
                                      ? '${comments[index].userId!.avatar}'
                                      : '${comments[index].centerId!.avatar}',
                                ),
                              ),
                            ),
                          ),
                          title: Container(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 10.0, 4.0, 4.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      comments[index].userId != null
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                          userId:
                                                              comments[index]
                                                                  .userId!
                                                                  .id)))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileCenterPage(
                                                        centerId:
                                                            comments[index]
                                                                .centerId!
                                                                .id),
                                              ),
                                            );
                                    },
                                    child: Text(
                                      // data[i]['name'],
                                      comments[index].userId != null
                                          ? '${comments[index].userId!.firstName} ${comments[index].userId!.lastName}'
                                          : '${comments[index].centerId!.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    )),
                                Text(
                                  // data[i]['message'],
                                  comments[index].content,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // trailing: IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(
                          //       Icons.favorite,
                          //       color: Colors.red,
                          //     )),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: Text('No comments yet.'));
          }
        });
    //tất cả các cmt của 1 bài post
  }

  @override
  Widget build(BuildContext context) {
    user_comment.User userCmt = user_comment.User(
        id: '',
        firstName: '',
        lastName: '',
        avatar: '',
        address: '',
        phoneNumber: '',
        email: '',
        status: '');
    center_comment.PetCenter centerCmt = center_comment.PetCenter(
        id: '',
        name: '',
        avatar: '',
        address: '',
        phoneNumber: '',
        email: '',
        status: '');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300),
            ),
            const SizedBox(height: 10),
            Text(
              'Comment',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Khoảng cách giữa "Comment" và dấu gạch ngang
            SizedBox(height: 4),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.send_sharp,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey.shade200,
            height: 1, // Chiều cao của đường gạch ngang
          ),
          Expanded(
            child: Container(
              child: CommentBox(
                userImage:
                    CommentBox.commentImageParser(imageURLorPath: avatarURL),
                child: commentChild([]),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () async {
                  if (formKey.currentState!.validate()) {
                    String commentText = commentController.text.toString();

                    FocusScope.of(context).unfocus();
                    commentController.clear();

                    var id = await postComment(widget.postId, commentText);
                    if (id != '') {
                      var currentClient = await getCurrentClient();

                      if (currentClient.role == 'USER') {
                        userCmt = user_comment.User(
                          id: currentClient.id,
                          firstName: currentClient.firstName,
                          lastName: currentClient.lastName,
                          avatar: currentClient.avatar,
                          address: '',
                          phoneNumber: '',
                          email: '',
                          status: '',
                        );
                      } else {
                        centerCmt = center_comment.PetCenter(
                          id: currentClient.id,
                          name: currentClient.name,
                          avatar: currentClient.avatar,
                          address: '',
                          phoneNumber: '',
                          email: '',
                          status: '',
                        );
                      }

                      Comment newComment = Comment(
                        id: id.toString(),
                        userId: userCmt,
                        centerId: centerCmt,
                        content: commentText,
                      );

                      // Gửi comment thông qua Socket.IO
                      socket.emit('comment', newComment.toMap());
                    }
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                sendWidget:
                    Icon(Icons.send_sharp, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Đóng kết nối Socket.IO hoặc thực hiện các tác vụ khác trước khi widget bị hủy
    // socket.disconnect();
    super.dispose();
  }

  Future<void> _showDeleteConfirmationDialog(
      String postId, String commentId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Loading(context);
                // Gọi hàm xóa comment khi người dùng xác nhận
                var message = await deleteComment(postId, commentId);
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                String commentId2 = extractCommentId(message);
                if (commentId2 != '') {
                  setState(() {
                    commentsFuture.then((comments) {
                      comments
                          .removeWhere((comment) => comment.id == commentId2);
                      return comments;
                    });
                  });
                  notification('The comment has been deleted', false);
                } else
                  notification(message, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String extractCommentId(String commentText) {
    RegExp regExp =
        RegExp(r'Comment ([a-zA-Z0-9]+) has been successfully deleted!');
    Match? match = regExp.firstMatch(commentText);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    } else {
      return ''; // Trả về giá trị mặc định hoặc thông báo lỗi nếu không tìm thấy ID
    }
  }
}
