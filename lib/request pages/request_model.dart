// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

RequestModel requestModelFromJson(String str) =>
    RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    required this.title,
    required this.category,
    required this.rate,
    required this.location,
    required this.description,
  });

  String title;
  List<String> category;
  String rate;
  String location;
  String description;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        title: json["title"],
        category: List<String>.from(json["category"].map((x) => x)),
        rate: json["rate"],
        location: json["location"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": List<dynamic>.from(category.map((x) => x)),
        "rate": rate,
        "location": location,
        "description": description,
      };
}
