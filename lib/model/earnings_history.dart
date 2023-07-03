import 'package:cloud_firestore/cloud_firestore.dart';

class EarningsHistory {
  final DateTime date;
  final double amount;
  final String reason;
  final String from;
  final String to;

  EarningsHistory(
      {required this.from,
      required this.to,
      required this.date,
      required this.amount,
      required this.reason});

  factory EarningsHistory.fromJson(Map<String, dynamic> json) {
    return EarningsHistory(
      date: (json['date'] as Timestamp).toDate(),
      amount: double.parse(json['amount'].toString()),
      reason: json['reason'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'reason': reason,
      'from': from,
      'to': to
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'reason': reason,
      'from': from,
      'to': to
    };
  }
}
