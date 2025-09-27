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
      if (profilePicture != null && profilePicture!.trim() != '')
        'profilePic': await MultipartFile.fromFile(profilePicture!),
      if (userName != null && userName!.trim() != '')
        'userName': userName!.trim().toLowerCase(),
    });

    //TODO add pushNotificationToken
  }
}
