import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final int rating;
  final String? message;
  final String jobId;
  final String rateeId;
  final String authorId;
  final DateTime createdAt;

  Rating(
      {required this.rating,
      this.message,
      required this.jobId,
      required this.rateeId,
      required this.authorId,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'message': message,
      'jobId': jobId,
      'rateeId': rateeId,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'] as int,
      message: json['message'] as String?,
      jobId: json['jobId'] as String,
      rateeId: json['rateeId'] as String,
      authorId: json['authorId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
