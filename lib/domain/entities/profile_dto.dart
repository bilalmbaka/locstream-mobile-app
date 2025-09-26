import 'package:dio/dio.dart';

class ProfileDto {
  const ProfileDto({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePicture,
    this.plusCode,
    this.country,
    this.userName,
    this.pushNotificationToken,
    this.countryFlag,
  });

  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? plusCode;
  final String? country;
  final String? profilePicture;
  final String? userName;
  final String? pushNotificationToken;
  final String? countryFlag;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (firstName != null && firstName!.trim() != "")
        "firstName": firstName!.trim(),
      if (lastName != null && lastName!.trim() != "")
        "lastName": lastName!.trim(),
      if (phoneNumber != null && phoneNumber!.trim() != "")
        "phone": phoneNumber!.trim(),
      if (plusCode != null && plusCode!.trim() != "")
        "plusCode": plusCode!.trim(),
      if (country != null && country!.trim() != "") "country": country!.trim(),
      if (profilePicture != null && profilePicture!.trim() != "")
        "profilePic": await MultipartFile.fromFile(profilePicture!),
      if (userName != null && userName!.trim() != "")
        "userName": userName!.trim(),
      if (countryFlag != null && countryFlag!.trim() != "")
        "countryFlag": countryFlag!.trim(),
    });

    //TODO add pushNotificationToken
  }
}
