// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProfileResponse _$CreateProfileResponseFromJson(
  Map<String, dynamic> json,
) => CreateProfileResponse(
  response: json['response'] == null
      ? null
      : Response.fromJson(json['response'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateProfileResponseToJson(
  CreateProfileResponse instance,
) => <String, dynamic>{'response': instance.response};

Response _$ResponseFromJson(Map<String, dynamic> json) =>
    Response(accessToken: json['accessToken'] as String?);

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
};
