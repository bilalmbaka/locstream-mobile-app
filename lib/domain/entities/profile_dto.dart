import 'package:dio/dio.dart';
import 'package:locstream/data/model/location_models.dart';

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
    this.location
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
  final LocationModel? location;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (profilePicture != null && profilePicture!.trim() != '')
        'profilePic': await MultipartFile.fromFile(profilePicture!),
      if (userName != null && userName!.trim() != '')
        'userName': userName!.trim().toLowerCase(),
      if (location != null)
        'currentLocation': location!.toJson()
    });

    //TODO add pushNotificationToken
  }
}
