import 'package:cloud_firestore/cloud_firestore.dart';

import 'contact.dart';
import 'identification.dart';

class Profile {
  String? userUid;
  final String name;
  final List<String> skills;
  final List<Contact> contacts;
  final Identification identification;
  final Gender gender;
  final OwnerType ownerType;
  final String? organizationName;

  Profile({
    this.userUid,
    required this.name,
    required this.skills,
    required this.contacts,
    required this.identification,
    required this.gender,
    required this.ownerType,
    this.organizationName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String,
      skills: (json['skills'] as List<dynamic>).cast<String>(),
      contacts: (json['contacts'] as List<dynamic>)
          .map((contact) => Contact.fromJson(contact))
          .toList(),
      identification: Identification.fromJson(json['identification']),
      gender: _parseGender(json['gender']),
      ownerType: _parseOwnerType(json['ownerType']),
      organizationName: json['organizationName'] as String?,
    );
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Profile.fromJson(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'skills': skills,
      'contacts': contacts.map((contact) => contact.toMap()).toList(),
      'identification': identification.toMap(),
      'gender': gender.name,
      'ownerType': ownerType.name,
      'organizationName': organizationName,
    };
  }

  static Gender _parseGender(String gender) {
    if (gender == 'male') {
      return Gender.male;
    } else if (gender == 'female') {
      return Gender.female;
    } else {
      throw Exception('Invalid gender value: $gender');
    }
  }

  static OwnerType _parseOwnerType(String ownerType) {
    return OwnerType.values.firstWhere(
        (element) => ownerType == element.name.toLowerCase(),
        orElse: () => OwnerType.individual);
  }

  @override
  String toString() {
    return 'Profile{name: $name, gender: $gender';
  }
}

enum Gender { male, female }

enum OwnerType { individual, organization }
