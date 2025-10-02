import 'package:locstream/data/model/asset_model.dart';
import 'package:locstream/data/model/location_models.dart';

class User {
  final String id;
  final String email;
  final String? userName;
  final bool? emailVerified;
  final bool? disabled;
  final String?
  disabledReason; // This was declared but not used in constructor or methods, added to them.
  final String?
  accessToken; // This was declared but not used in constructor or methods, added to them.
  final String?
  refreshToken; // This was declared but not used in constructor or methods, added to them.
  final LocationModel?
  currentLocation; // This was declared but not used in constructor or methods, added to them.
  final String? currentAddress;
  final DateTime? lastSeen;
  final Asset? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const User({
    required this.id,
    required this.email,
    this.userName,
    this.emailVerified = false,
    this.disabled = true,
    this.disabledReason,
    this.accessToken,
    this.refreshToken,
    this.currentLocation,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.currentAddress,
    this.lastSeen,
  });

  // Factory constructor for creating from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String?,
      emailVerified: json['emailVerified'],
      disabled: json['disabled'],
      disabledReason: json['disabledReason'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      currentLocation: json['currentLocation'] != null
          ? LocationModel.fromJson(
              json['currentLocation'] as Map<String, dynamic>,
            )
          : null,
      profilePicture: json['profilePicture'] != null
          ? Asset.fromJson(
              json['profilePicture'] as Map<String, dynamic>,
            ) // Corrected parsing
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      currentAddress: json['currentAddress'],
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
    );
  }

  // Method for converting to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'emailVerified': emailVerified,
      'disabled': disabled,
      'disabledReason': disabledReason,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'currentLocation': currentLocation?.toJson(),
      'profilePicture': profilePicture?.toJson(), // Corrected serialization
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'currentAddress': currentAddress,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  // CopyWith method for creating modified copies
  User copyWith({
    String? id,
    String? email,
    String? userName,
    bool? emailVerified,
    bool? disabled,
    String? disabledReason,
    String? accessToken,
    String? refreshToken,
    LocationModel? currentLocation,
    Asset? profilePicture, // Corrected type to Asset?
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? currentAddress,
    DateTime? lastSeen,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      emailVerified: emailVerified ?? this.emailVerified,
      disabled: disabled ?? this.disabled,
      disabledReason: disabledReason ?? this.disabledReason,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      currentLocation: currentLocation ?? this.currentLocation,
      profilePicture: profilePicture ?? this.profilePicture,
      // Corrected usage
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      currentAddress: currentAddress ?? this.currentAddress,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

extension UserExtension on User {
  get initials => userName == null ? '_' : userName![0];
}
