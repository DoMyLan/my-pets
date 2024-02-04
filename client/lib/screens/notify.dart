import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/notify.dart';
import 'package:found_adoption_application/screens/comment_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/status_adopt.dart';
import 'package:found_adoption_application/screens/post_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/status_adopt.dart';
import 'package:found_adoption_application/services/notify/notifyAPI.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        title: const Row(
          children: [
         
            SizedBox(width: 8.0),
            Text(
              'Notification',
              style: TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0)),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future: getNotify(),
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
              List<Notify> notifies = snapshot.data as List<Notify>;
              return ListView.builder(
                itemCount: notifies.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notifies[index]);
                },
              );
            } else {
              return const Center(
                child: Icon(
                  Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                  size: 48.0,
                  color: Colors.grey,
                ),
              );
            }
          }),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final Notify notifies;

  const NotificationCard(this.notifies, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    String timeAgo = timeago.format(
        widget.notifies.createdAt!.subtract(const Duration(seconds: 10)),
        locale: 'en_short');

    return GestureDetector(
        onTap: () async {
          var currentClient = await getCurrentClient();
          if (currentClient.role == 'USER') {
            if (widget.notifies.title == 'Adoption') {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatusAdoptUser()));
            } else if (widget.notifies.title == 'Post') {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostScreen(postId: widget.notifies.idDestinate!)));
            } else if (widget.notifies.title == 'Comment') {

              print(widget.notifies.idDestinate);
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommentScreen(postId: widget.notifies.idDestinate!)));
            }
          } else {
            if (widget.notifies.title == 'Adoption') {
              // ignore: use_build_context_synchronously
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StatusAdopt()));
            } else if (widget.notifies.title == 'Post') {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostScreen(postId: widget.notifies.idDestinate!)));
            } else if (widget.notifies.title == 'Comment') {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommentScreen(postId: widget.notifies.idDestinate!)));
            }
          }
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(widget.notifies.avatar),
            ),
            title: Text(
              widget.notifies.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.notifies.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sent $timeAgo',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(widget.notifies.content),
              ],
            ),
          ),
        ));
  }
}
