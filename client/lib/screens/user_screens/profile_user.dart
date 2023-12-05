import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/repository/get_all_post_api.dart';
import 'package:found_adoption_application/repository/profile_api.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
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

  @override
  void initState() {
    super.initState();
    petStoriesPosts = getAllPostPersonal(widget.userId);
    userFuture = getProfile(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
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
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sử dụng TypewriterAnimatedTextKit để tạo hiệu ứng chữ chạy
              TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 200),
                totalRepeatCount:
                    1, // Số lần lặp (1 lần để chạy từ đầu đến cuối)
                text: ['Profile'],
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<InfoUser>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still loading, show a loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // If there is an error fetching data, show an error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // If data is successfully fetched, display the form
                InfoUser user = snapshot.data!;
                return SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ảnh đại diện
                          InkWell(
                            onTap: () {
                              // Hàm xử lý khi click vào ảnh avatar
                              _showFullScreenImage(context, user.avatar);
                            },
                            child: Hero(
                              tag: 'avatarTag',
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(
                                    '${user.avatar}'), // Thay đổi đường dẫn ảnh
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Họ và Tên
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),

                          // Contact me
                          buildSectionHeader('Contact me', Icons.mail),
                          buildContactInfo(
                              user.phoneNumber, Icons.phone, 'phone'),
                          buildContactInfo(user.email, Icons.email, 'email'),
                          buildContactInfo(
                              user.address,
                              IconData(0xe3ab, fontFamily: 'MaterialIcons'),
                              ''),
                          SizedBox(height: 16.0),

                          // About me
                          buildSectionHeader('About me', Icons.info),
                          buildInfo(
                              'Mình là một lập trình viên đam mê Flutter và đang xây dựng ứng dụng tuyệt vời!'),
                          SizedBox(height: 16.0),

                          // Experience
                          buildSectionHeader('Experience', Icons.work),
                          buildInfo(
                              '3 năm kinh nghiệm trong lĩnh vực phát triển ứng dụng di động.'),
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
                                  labelColor: Theme.of(context).primaryColor,
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
            }));
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
            return Text('Error: ${snapshot.error}');
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
              return Text('Post list is null');
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
      onTap: () {
        if (type == 'email') {
          launchEmail(info);
        } else if (type == 'phone') {
          makePhoneCall('tel:${info}');
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 16.0),
          SizedBox(width: 8.0),
          Text(
            info,
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
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
}
