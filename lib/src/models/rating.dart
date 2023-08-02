import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final Timestamp date;
  final double rating;
  final String? review;
  final Map<String, dynamic> reviewer;

  Rating({
    required this.date,
    required this.rating,
    this.review,
    required this.reviewer,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'rating': rating,
    'review': review ?? '',
    'reviewer': reviewer,
  };
}