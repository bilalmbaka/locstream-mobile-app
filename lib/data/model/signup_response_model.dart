import 'package:equatable/equatable.dart';

import 'user_model.dart';

class AuthResponseModel extends Equatable {
  final User user;
  final String accessToken;
  final String refreshToken;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      user: User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "user": user.toJson()
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
