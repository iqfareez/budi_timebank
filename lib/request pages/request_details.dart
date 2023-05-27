import 'package:json_annotation/json_annotation.dart';
//part 'RequestDetails.g.dart';

@JsonSerializable()
class RequestDetails {
  //title
  //category
  //rate
  //location
  //description
  final String title;
  final int rate;

  RequestDetails({
    required this.title,
    required this.rate,
  });

  // factory RequestDetails.fromJson(Map<String, dynamic> json) =>
  //     _$RequestDetailsFromJson(json);

  // Map<String, dynamic> toJson() => _$RequestDetailsToJson(this);

  // factory RequestDetails.fromJson(Map<String, dynamic> json)=
  //   title: json['title'],
  //   rate: json['rate'];

  // Map<String, dynamic> toJson() => {
  //   'title': title,
  //   'rate': rate
  // };

  // @override
  // String toString() => 'Request{title: $title, rate: $rate';
}
