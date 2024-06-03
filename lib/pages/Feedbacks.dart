import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/widgets/ratingreview.dart';

class FeedbackReviews extends StatefulWidget {
  const FeedbackReviews({super.key});

  @override
  State<FeedbackReviews> createState() => _FeedbackReviewsState();
}

class _FeedbackReviewsState extends State<FeedbackReviews> {
  User? curr = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            MainFont(
              title: "Feedbacks",
              fsize: 23,
            ),
            RatingsView(
              isadmin: true,
              adminprofile: curr!.uid,
            )
          ],
        ),
      ),
    );
  }
}
