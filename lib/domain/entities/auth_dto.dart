class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      "email": email.trim(),
      "password": password,
      'role': 'user'
    };
  }
}

class SignupDto {
  final String email;
  final String password;
  final String userName;

  const SignupDto({
    required this.email,
    required this.password,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'userName': userName,
    };
  }

  SignupDto copyWith({
    String? email,
    String? password,
    String? userName,
  }) {
    return SignupDto(
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName
    );
  }
}

class ResetPasswordDto {
  final String email;
  final String otp;
  final String password;

  ResetPasswordDto(
      {required this.email, required this.otp, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': password,
    };
  }
}
