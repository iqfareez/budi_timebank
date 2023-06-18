class Identification {
  final IdentificationType identificationType;
  final String value;

  Identification({required this.identificationType, required this.value});

  factory Identification.fromJson(Map<String, dynamic> json) {
    return Identification(
      identificationType: _parseIdentificationType(json['type']),
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': identificationType.name,
      'value': value,
    };
  }

  static IdentificationType _parseIdentificationType(
      String identificationType) {
    switch (identificationType) {
      case 'mykad':
        return IdentificationType.mykad;
      case 'matricno':
        return IdentificationType.matricno;
      case 'passport':
        return IdentificationType.passport;
      default:
        throw FormatException(
            'Invalid identification type: $identificationType');
    }
  }
}

enum IdentificationType { mykad, matricno, passport }
