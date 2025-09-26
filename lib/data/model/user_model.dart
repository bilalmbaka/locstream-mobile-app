import '../../core/utils/extensions/string_extension.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool disabled;
  final bool emailVerified;
  final String? profilePicture;
  final String? country;
  final String? countryFlag;
  final String? plusCode;
  final String? userName;

  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.disabled,
    required this.emailVerified,
    required this.country,
    required this.plusCode,
    required this.countryFlag,
    this.deletedAt,
    this.profilePicture,
    this.userName,
  });

  // Factory constructor for creating from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        userName: json['userName'],
        phoneNumber: json['phone'] as String,
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        disabled: json['disabled'] as bool,
        emailVerified: json['emailVerified'] as bool,
        profilePicture: json['profilePic'],
        country: json['country'],
        plusCode: json['plusCode'],
        countryFlag: json['countryFlag']);
  }

  // Method for converting to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'phone': phoneNumber,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'disabled': disabled,
      'emailVerified': emailVerified,
      'profilePic': profilePicture,
      'country': country,
      'plusCode': plusCode,
      'countryFlag': countryFlag,
    };
  }

  // CopyWith method for creating modified copies
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? userName,
    String? phoneNumber,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? disabled,
    bool? emailVerified,
    String? profilePicture,
    String? country,
    String? plusCode,
    String? countryFlag,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      disabled: disabled ?? this.disabled,
      emailVerified: emailVerified ?? this.emailVerified,
      profilePicture: profilePicture ?? this.profilePicture,
      country: country ?? this.country,
      plusCode: plusCode ?? this.plusCode,
      countryFlag: countryFlag ?? this.countryFlag,
    );
  }

  // Convenience getter for full name
  String get fullName =>
      '${firstName.firstLetterToUpperCase()} ${lastName.firstLetterToUpperCase()}';

  // Convenience getter to check if user is active
  bool get isActive => !disabled && deletedAt == null;

  // Convenience getter to check if user is fully verified
  bool get isFullyVerified => emailVerified;

  String get initials {
    return userName != null && userName!.trim().isNotEmpty
        ? userName!.substring(0, 2)
        : "${firstName.substring(0, 1)}${lastName.substring(0, 1)}";
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.userName == userName &&
        other.phoneNumber == phoneNumber &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.disabled == disabled &&
        other.emailVerified == emailVerified &&
        other.profilePicture == profilePicture;
  }

  // Hash code
  @override
  int get hashCode {
    return Object.hash(
      firstName,
      lastName,
      email,
      userName,
      phoneNumber,
      id,
      createdAt,
      updatedAt,
      deletedAt,
      disabled,
      emailVerified,
      profilePicture,
      country,
      plusCode,
    );
  }

  // String representation
  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, email: $email, userName: $userName, phoneNumber: $phoneNumber, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, disabled: $disabled, emailVerified: $emailVerified, profilePicture: $profilePicture, country: $country, plusCode: $plusCode)';
  }
}
