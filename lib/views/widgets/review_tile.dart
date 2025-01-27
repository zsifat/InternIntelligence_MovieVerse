import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/models/movie_review_model.dart';
import 'package:movie_app/config/app_settings.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Format the date using the intl package
    String formattedDate = DateFormat('dd-MMM yyyy').format(review.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User's Name, Date, and Rating in a Clean Line
          Row(
            children: [
              Text(
                review.userName,
                style: AppSettings.regularSemibold.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                formattedDate,
                style: AppSettings.regular.copyWith(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review.rating??0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Review Text (If available)
          if (review.review != null && review.review!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                review.review!,
                style: AppSettings.regular.copyWith(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ),
          // No Review Placeholder
          if (review.review == null || review.review!.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                'No review provided.',
                style: AppSettings.regular.copyWith(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
