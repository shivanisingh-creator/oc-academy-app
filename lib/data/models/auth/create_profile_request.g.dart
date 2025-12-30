// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProfileRequest _$CreateProfileRequestFromJson(
  Map<String, dynamic> json,
) => CreateProfileRequest(
  currentDevice: json['currentDevice'] as String,
  deviceToken: json['deviceToken'] as String,
  fcmToken: json['fcmToken'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  mobileNumber: json['mobileNumber'] as String,
  countryId: (json['countryId'] as num).toInt(),
  email: json['email'] as String,
  registrationSource: json['registrationSource'] as String,
  preAccessToken: json['preAccessToken'] as String,
  professionId: (json['professionId'] as num).toInt(),
  title: json['title'] as String,
  otherProfession: json['otherProfession'] as String?,
  primaryRole: json['primaryRole'] as String?,
  otherProfessionId: (json['otherProfessionId'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateProfileRequestToJson(
  CreateProfileRequest instance,
) => <String, dynamic>{
  'currentDevice': instance.currentDevice,
  'deviceToken': instance.deviceToken,
  'fcmToken': instance.fcmToken,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'mobileNumber': instance.mobileNumber,
  'countryId': instance.countryId,
  'email': instance.email,
  'registrationSource': instance.registrationSource,
  'preAccessToken': instance.preAccessToken,
  'professionId': instance.professionId,
  'title': instance.title,
  'otherProfession': instance.otherProfession,
  'primaryRole': instance.primaryRole,
  'otherProfessionId': instance.otherProfessionId,
};
