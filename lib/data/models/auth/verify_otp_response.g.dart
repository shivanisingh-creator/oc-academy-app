// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      response: json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{'response': instance.response};

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
  isNewUser: json['isNewUser'] as bool?,
  accessToken: json['accessToken'] as String?,
  preAccessToken: json['preAccessToken'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
  email: json['email'] as String?,
  message: json['message'] as String?,
  status: json['status'] as String?,
  appleUserId: json['appleUserId'] as String?,
  isMobileVerified: json['isMobileVerified'] as bool?,
  productAccess: json['productAccess'],
);

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
  'isNewUser': instance.isNewUser,
  'accessToken': instance.accessToken,
  'preAccessToken': instance.preAccessToken,
  'mobileNumber': instance.mobileNumber,
  'email': instance.email,
  'message': instance.message,
  'status': instance.status,
  'appleUserId': instance.appleUserId,
  'isMobileVerified': instance.isMobileVerified,
  'productAccess': instance.productAccess,
};
