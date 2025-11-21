import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOtpRequest {
  final String currentDevice;
  final String deviceToken;
  final String fcmToken;
  final String mobileNumber;
  final String otp;
  final String registrationSource;
  final bool isLead;
  final int productType;

  VerifyOtpRequest({
    required this.currentDevice,
    required this.deviceToken,
    required this.fcmToken,
    required this.mobileNumber,
    required this.otp,
    required this.registrationSource,
    required this.isLead,
    required this.productType,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}
