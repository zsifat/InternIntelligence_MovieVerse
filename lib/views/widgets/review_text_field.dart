import 'package:flutter/material.dart';
import 'package:movie_app/config/app_settings.dart';

class ReviewTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onReviewSubmitted;

  const ReviewTextField({
    super.key,
    required this.controller,
    required this.onReviewSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Type your review here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: AppSettings.blueCustom),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onReviewSubmitted(controller.text);
              controller.clear(); // Clear the text field after submission
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please write a review before submitting."),
                ),
              );
            }
          },
          child: Text("Submit Review",style: AppSettings.regular.copyWith(fontSize: 12,color: AppSettings.whiteCustom),),
        ),
      ],
    );
  }
}
