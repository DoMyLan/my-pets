import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard({super.key});

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Lan.jpg'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'LanLan',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            const TRatingBar(rating: 4),
            const SizedBox(
              width: 10,
            ),
            Text(
              '01 Nov, 2023',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const ReadMoreText(
          'Ratings and Reviews are verified and are from people who use the same type of device that you use. AAAAAAAAAAAAAAA',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: 'show less',
          trimCollapsedText: 'show more',
          moreStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          lessStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 3,
        ),
        
        Container(
          margin: EdgeInsets.only(left: 15),         
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hữu Đạt',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '02 Nov, 2023',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const ReadMoreText(
                  'Ratings and Reviews are verified and are from people who use the same type of device that you use. AAAAAAAAAAAAAAA',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: 'show less',
                  trimCollapsedText: 'show more',
                  moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
