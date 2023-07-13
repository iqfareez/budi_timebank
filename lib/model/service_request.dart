import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  String? id;
  String title;
  String description;
  Location location;
  ServiceRequestStatus status;
  double rate;
  List<String> media;
  String requestorId;
  List<String> applicants;
  String? providerId;
  String category;
  double timeLimit;
  DateTime date;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? startedAt;
  DateTime? completedAt;

  ServiceRequest({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.rate,
    required this.media,
    required this.status,
    required this.requestorId,
    this.providerId,
    required this.applicants,
    required this.category,
    required this.timeLimit,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.startedAt,
    this.completedAt,
  });

  @override
  String toString() {
    return "{ServiceRequest ${id == null ? '($id)' : ""}: $title, $rate, $location, $requestorId, $category, $timeLimit, $date}";
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'title': title,
      'description': description,
      'location': location.toMap(),
      'rate': rate,
      'media': media,
      'requestorId': requestorId,
      'providerId': providerId,
      'status': status.name,
      'applicants': applicants,
      'category': category,
      'timeLimit': timeLimit,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'startedAt': startedAt == null ? null : Timestamp.fromDate(startedAt!),
      'completedAt':
          completedAt == null ? null : Timestamp.fromDate(completedAt!),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'rate': rate,
      'status': status.name, // 'pending', 'accepted', 'rejected', 'completed'
      'media': media,
      'requestorId': requestorId,
      'providerId': providerId,
      'applicants': applicants,
      'category': category,
      'timeLimit': timeLimit,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      title: json['title'],
      description: json['description'],
      location: Location.fromJson(json['location']),
      rate: json['rate'],
      media: List<String>.from(json['media']),
      requestorId: json['requestorId'],
      providerId: json['providerId'],
      applicants: List<String>.from(json['applicants']),
      status: ServiceRequestStatus.values
          .firstWhere((e) => e.name == json['status']),
      category: json['category'],
      timeLimit: json['timeLimit'],
      date: (json['date'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDate(),
      startedAt: json['startedAt'] == null
          ? null
          : (json['startedAt'] as Timestamp).toDate(),
      completedAt: json['completedAt'] == null
          ? null
          : (json['completedAt'] as Timestamp).toDate(),
    );
  }

  factory ServiceRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceRequest(
      title: data['title'],
      description: data['description'],
      location: data['location'],
      rate: data['rate'],
      media: List<String>.from(data['media']),
      status: ServiceRequestStatus.values
          .firstWhere((e) => e.name == data['status']),
      requestorId: data['requestorId'],
      providerId: data['providerId'],
      applicants: List<String>.from(data['applicants']),
      category: data['category'],
      timeLimit: data['timeLimit'] as double,
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] == null
          ? null
          : (data['updatedAt'] as Timestamp).toDate(),
      startedAt: data['startedAt'] == null
          ? null
          : (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] == null
          ? null
          : (data['completedAt'] as Timestamp).toDate(),
    );
  }
}

class Location {
  final GeoPoint coordinate;
  final String address;
  final String city;
  final String state;

  Location({
    required this.coordinate,
    required this.address,
    required this.city,
    required this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      coordinate: json['coordinate'] as GeoPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'coordinate': coordinate,
    };
  }

  @override
  String toString() {
    return "{Location: $address, $city, $state, $coordinate}";
  }
}

enum ServiceRequestStatus {
  pending,
  accepted,
  ongoing,
  completed,
  completedVerified,
  cancelled,
  rejected,
}
