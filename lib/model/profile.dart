import 'package:cloud_firestore/cloud_firestore.dart';

import 'contact.dart';
import 'identification.dart';

class Profile {
  final String name;
  final List<String> skills;
  final List<Contact> contacts;
  final Identification identification;
  final Gender gender;

  Profile({
    required this.name,
    required this.skills,
    required this.contacts,
    required this.identification,
    required this.gender,
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
      'gender': gender.name
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

  @override
  String toString() {
    return 'Profile{name: $name, gender: $gender';
  }
}

enum Gender { male, female }
