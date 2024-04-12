import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/video_widget.dart';
import 'package:found_adoption_application/models/short_video.dart';

class ListVideoApp extends StatefulWidget {
  const ListVideoApp({super.key});

  @override
  _ListVideoAppState createState() => _ListVideoAppState();
}

class _ListVideoAppState extends State<ListVideoApp> {
  List<ShortVideo> videoPost = [
    ShortVideo(
        id: "1",
        name: "Đặng Văn Tuấn",
        avatar:
            "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/400540394_1407008996562252_749359663923929168_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH3zX6VaKdvODCCq4bzSiiyouYCxwplC92i5gLHCmUL3ZT0e76WUUCqpLvh7OW-UMbxLYcN_GaGbMMUqam6-s27&_nc_ohc=t52jhsohME0Ab7-uGz4&_nc_ht=scontent.fsgn19-1.fna&oh=00_AfBhT0UO280RVx90cZguiZkSury_dB1O9J46YffSyafpKA&oe=661D9171",
        content: 'Hi',
        video:
            "https://res.cloudinary.com/dfaea99ew/video/upload/v1712397007/video-pets/fukpvsjhs7adrea3wkf9.mp4"),
    ShortVideo(
        id: "1",
        name: "Đặng Văn Tuấn",
        avatar:
            "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/400540394_1407008996562252_749359663923929168_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH3zX6VaKdvODCCq4bzSiiyouYCxwplC92i5gLHCmUL3ZT0e76WUUCqpLvh7OW-UMbxLYcN_GaGbMMUqam6-s27&_nc_ohc=t52jhsohME0Ab7-uGz4&_nc_ht=scontent.fsgn19-1.fna&oh=00_AfBhT0UO280RVx90cZguiZkSury_dB1O9J46YffSyafpKA&oe=661D9171",
        content: 'Hi',
        video:
            "https://res.cloudinary.com/dfaea99ew/video/upload/v1712397007/video-pets/fukpvsjhs7adrea3wkf9.mp4"),
    ShortVideo(
        id: "1",
        name: "Đặng Văn Tuấn",
        avatar:
            "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/400540394_1407008996562252_749359663923929168_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH3zX6VaKdvODCCq4bzSiiyouYCxwplC92i5gLHCmUL3ZT0e76WUUCqpLvh7OW-UMbxLYcN_GaGbMMUqam6-s27&_nc_ohc=t52jhsohME0Ab7-uGz4&_nc_ht=scontent.fsgn19-1.fna&oh=00_AfBhT0UO280RVx90cZguiZkSury_dB1O9J46YffSyafpKA&oe=661D9171",
        content: 'Hi',
        video:
            "https://res.cloudinary.com/dfaea99ew/video/upload/v1712397007/video-pets/fukpvsjhs7adrea3wkf9.mp4"),
    ShortVideo(
        id: "1",
        name: "Đặng Văn Tuấn",
        avatar:
            "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/400540394_1407008996562252_749359663923929168_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH3zX6VaKdvODCCq4bzSiiyouYCxwplC92i5gLHCmUL3ZT0e76WUUCqpLvh7OW-UMbxLYcN_GaGbMMUqam6-s27&_nc_ohc=t52jhsohME0Ab7-uGz4&_nc_ht=scontent.fsgn19-1.fna&oh=00_AfBhT0UO280RVx90cZguiZkSury_dB1O9J46YffSyafpKA&oe=661D9171",
        content: 'Hi',
        video:
            "https://res.cloudinary.com/dfaea99ew/video/upload/v1712397007/video-pets/fukpvsjhs7adrea3wkf9.mp4"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: videoPost.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return VideoApp(
          videoPost: videoPost[index],
        );
      },
    );
  }
}
