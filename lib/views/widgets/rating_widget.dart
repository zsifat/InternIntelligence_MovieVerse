import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/movie_review_model.dart';

class StarRating extends ConsumerStatefulWidget {
  final int maxStars;// Maximum number of stars
  final double initialRating; // Initial rating value
  final Function(double) onRatingChanged;
  final bool isReadOnly;
  final double iconSize;// Callback to handle rating changes

  const StarRating({
    super.key,
    this.maxStars = 5,
    required this.initialRating,
    this.isReadOnly = false,
    this.iconSize = 25,
    required this.onRatingChanged,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends ConsumerState<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    print(_currentRating);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        return GestureDetector(
          onTap: widget.isReadOnly ? (){} : () {
            setState(() {
              _currentRating = index + 1.0;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: widget.iconSize,
          ),
        );
      }),
    );
  }
}
