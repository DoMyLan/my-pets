import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TRatingBar extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingChanged;

  const TRatingBar({
    Key? key,
    required this.initialRating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _TRatingBarState createState() => _TRatingBarState();
}

class _TRatingBarState extends State<TRatingBar> {
  late double _rating;
  late String _ratingText;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _ratingText = getRatingText(_rating);
  }

  String getRatingText(double rating) {
    if (rating == 1) {
      return 'Tệ';
    } else if (rating == 2) {
      return 'Không hài lòng';
    } else if (rating == 3) {
      return 'Bình thường';
    } else if (rating == 4) {
      return 'Hài lòng';
    } else {
      return 'Tuyệt vời';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RatingBar.builder(
          itemSize: 25,
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
              _ratingText = getRatingText(rating);
            });
            widget.onRatingChanged(rating);
          },
        ),
        SizedBox(width: 8), // Khoảng cách giữa RatingBar và Text
        Container(
          width: 65,
          child: Text(
            _ratingText,
            style: TextStyle(fontSize: 13, color: Color.fromRGBO(48, 96, 96, 1.0)),
          ),
        ),
      ],
    );
  }
}
