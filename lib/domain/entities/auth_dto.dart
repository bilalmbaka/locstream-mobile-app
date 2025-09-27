class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email.trim(), "password": password, 'role': 'user'};
  }
}

class SignupDto {
  final String email;
  final String password;

  const SignupDto({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email.toLowerCase().trim(), 'password': password};
  }

  SignupDto copyWith({String? email, String? password, String? userName}) {
    return SignupDto(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class ResetPasswordDto {
  final String email;
  final String otp;
  final String password;

  ResetPasswordDto({
    required this.email,
    required this.otp,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp, 'newPassword': password};
  }
}
