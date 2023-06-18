class Contact {
  final ContactType contactType;
  final String value;

  Contact({required this.contactType, required this.value});

  factory Contact.fromJson(Map<String, dynamic> json) {
    final contactType = _parseContactType(json['type']);
    final value = json['value'] as String;

    return Contact(contactType: contactType, value: value);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': contactType.name,
      'value': value,
    };
  }

  static ContactType _parseContactType(String contactTypeString) {
    switch (contactTypeString) {
      case 'whatsapp':
        return ContactType.whatsapp;
      case 'email':
        return ContactType.email;
      case 'phone':
        return ContactType.phone;
      case 'twitter':
        return ContactType.twitter;

      default:
        throw ArgumentError('Invalid ContactType value: $contactTypeString');
    }
  }
}

enum ContactType {
  whatsapp,
  email,
  phone,
  twitter,
}
