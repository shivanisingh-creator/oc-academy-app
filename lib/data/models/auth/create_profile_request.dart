import 'package:json_annotation/json_annotation.dart';

part 'create_profile_request.g.dart';

@JsonSerializable()
class CreateProfileRequest {
  final String currentDevice;
  final String deviceToken;
  final String fcmToken;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final int countryId;
  final String email;
  final String registrationSource;
  final String preAccessToken;
  final int professionId;
  final String title;

  CreateProfileRequest({
    required this.currentDevice,
    required this.deviceToken,
    required this.fcmToken,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.countryId,
    required this.email,
    required this.registrationSource,
    required this.preAccessToken,
    required this.professionId,
    required this.title,
  });

  factory CreateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProfileRequestToJson(this);
}
