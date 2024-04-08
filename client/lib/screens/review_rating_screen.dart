import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:found_adoption_application/custom_widget/user_review_card.dart';
import 'package:found_adoption_application/models/review.dart';
import 'package:found_adoption_application/services/post/review.dart';

class Rating {
  final int rating;
  int count;
  Rating({required this.rating, required this.count});
}

class ReviewProfileScreen extends StatefulWidget {
  final String centerId;
  const ReviewProfileScreen({super.key, required this.centerId});

  @override
  State<ReviewProfileScreen> createState() => _ReviewProfileScreenState();
}

class _ReviewProfileScreenState extends State<ReviewProfileScreen> {
  Future<List<Review>>? reviewFuture;
  List<Review> reviews = [];
  double ratingAverage = 5.0;
  List<Rating> rating = [
    Rating(rating: 5, count: 0),
    Rating(rating: 4, count: 0),
    Rating(rating: 3, count: 0),
    Rating(rating: 2, count: 0),
    Rating(rating: 1, count: 0),
  ];

  @override
  void initState() {
    super.initState();
    reviewFuture = getAllReviewOfCenter(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews & Rating'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: reviewFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                reviews = snapshot.data as List<Review>;

                if (reviews.isNotEmpty) {
                  ratingAverage = (reviews
                          .map((e) => e.rating)
                          .reduce((value, element) => value + element) /
                      reviews.length);

                  for (var i = 0; i < reviews.length; i++) {
                    if (reviews[i].rating == 5) {
                      rating[0].count++;
                    } else if (reviews[i].rating == 4) {
                      rating[1].count++;
                    } else if (reviews[i].rating == 3) {
                      rating[2].count++;
                    } else if (reviews[i].rating == 2) {
                      rating[3].count++;
                    } else if (reviews[i].rating == 1) {
                      rating[4].count++;
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "Xếp hạng và Đánh giá được xác minh và đến từ những người sử dụng cùng loại thiết bị mà bạn sử dụng"),
                      const SizedBox(
                        height: 20,
                      ),

                      //Rating
                      TOverallRating(
                          rating: rating, ratingAverage: ratingAverage, count: reviews.length),
                      TRatingBar(
                        rating: ratingAverage,
                      ),
                      Text(
                        "${reviews.length} đánh giá",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return UserReviewCard(review: reviews[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
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
      itemBuilder: (_, __) =>
          const Icon(Icons.star, color: Color.fromRGBO(48, 96, 96, 1.0)),
    );
  }
}

class TOverallRating extends StatelessWidget {
  final List<Rating> rating;
  final double ratingAverage;
  final int count;
  const TOverallRating({
    super.key,
    required this.rating,
    required this.ratingAverage, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              ratingAverage.toStringAsFixed(1),
              style: const TextStyle(
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
                value: rating[0].count / count.toDouble(),
              ),
              TProgressRatingIndicator(
                text: '4',
                value: rating[1].count / count.toDouble(),
              ),
              TProgressRatingIndicator(
                text: '3',
                value: rating[2].count / count.toDouble(),
              ),
              TProgressRatingIndicator(
                text: '2',
                value: rating[3].count / count.toDouble(),
              ),
              TProgressRatingIndicator(
                text: '1',
                value: rating[4].count / count.toDouble(),
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
