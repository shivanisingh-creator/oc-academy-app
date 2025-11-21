import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse {
  final Response? response;

  VerifyOtpResponse({this.response});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class Response {
  final bool? isNewUser;
  final String? accessToken;
  final String? preAccessToken;
  final String? mobileNumber;
  final String? email;
  final String? message;
  final String? status;
  final String? appleUserId;
  final bool? isMobileVerified;
  final dynamic productAccess;

  Response({
    this.isNewUser,
    this.accessToken,
    this.preAccessToken,
    this.mobileNumber,
    this.email,
    this.message,
    this.status,
    this.appleUserId,
    this.isMobileVerified,
    this.productAccess,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
