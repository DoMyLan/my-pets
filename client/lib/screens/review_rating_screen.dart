import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:found_adoption_application/custom_widget/user_review_card.dart';


class ReviewProfileScreen extends StatefulWidget {
  const ReviewProfileScreen({super.key});

  @override
  State<ReviewProfileScreen> createState() => _ReviewProfileScreenState();
}

class _ReviewProfileScreenState extends State<ReviewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews & Rating'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Ratings and Reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(
                height: 20,
              ),

              //Rating
              TOverallRating(),
              TRatingBar(
                rating: 3.5,
              ),
              Text(
                "123 bình luận",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 20,
              ),

              //List Review by user
              UserReviewCard(),

              UserReviewCard(),
              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class TRatingBar extends StatelessWidget {
  final double rating;
  const TRatingBar({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemSize: 20,
      unratedColor: Colors.grey,
      itemBuilder: (_, __) => Icon(Icons.star, color: Color.fromRGBO(48, 96, 96, 1.0)),
    );
  }
}





class TOverallRating extends StatelessWidget {
  const TOverallRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              '4.8',
              style: TextStyle(
                color: Color.fromRGBO(48, 96, 96, 1.0),
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              TProgressRatingIndicator(
                text: '5',
                value: 1.0,
              ),
              TProgressRatingIndicator(
                text: '4',
                value: 0.8,
              ),
              TProgressRatingIndicator(
                text: '3',
                value: 0.6,
              ),
              TProgressRatingIndicator(
                text: '2',
                value: 0.4,
              ),
              TProgressRatingIndicator(
                text: '1',
                value: 0.2,
              )
            ],
          ),
        )
      ],
    );
  }
}

class TProgressRatingIndicator extends StatelessWidget {
  final String text;
  final double value;
  const TProgressRatingIndicator(
      {super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        Expanded(
            flex: 11,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: LinearProgressIndicator(
                value: value,
                minHeight: 11,
                backgroundColor: Colors.grey,
                borderRadius: BorderRadius.circular(7),
                valueColor: const AlwaysStoppedAnimation(
                    Color.fromRGBO(48, 96, 96, 1.0)),
              ),
            ))
      ],
    );
  }
}
