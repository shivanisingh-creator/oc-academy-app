// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      currentDevice: json['currentDevice'] as String,
      deviceToken: json['deviceToken'] as String,
      fcmToken: json['fcmToken'] as String,
      mobileNumber: json['mobileNumber'] as String,
      otp: json['otp'] as String,
      registrationSource: json['registrationSource'] as String,
      isLead: json['isLead'] as bool,
      productType: (json['productType'] as num).toInt(),
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{
      'currentDevice': instance.currentDevice,
      'deviceToken': instance.deviceToken,
      'fcmToken': instance.fcmToken,
      'mobileNumber': instance.mobileNumber,
      'otp': instance.otp,
      'registrationSource': instance.registrationSource,
      'isLead': instance.isLead,
      'productType': instance.productType,
    };
