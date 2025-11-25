class SignupLoginGoogleResponse {
  final Response? response;

  SignupLoginGoogleResponse({this.response});

  factory SignupLoginGoogleResponse.fromJson(Map<String, dynamic> json) {
    return SignupLoginGoogleResponse(
      response:
          json['response'] != null ? Response.fromJson(json['response']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response?.toJson(),
    };
  }
}

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

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      isNewUser: json['isNewUser'],
      accessToken: json['accessToken'],
      preAccessToken: json['preAccessToken'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      message: json['message'],
      status: json['status'],
      appleUserId: json['appleUserId'],
      isMobileVerified: json['isMobileVerified'],
      productAccess: json['productAccess'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isNewUser': isNewUser,
      'accessToken': accessToken,
      'preAccessToken': preAccessToken,
      'mobileNumber': mobileNumber,
      'email': email,
      'message': message,
      'status': status,
      'appleUserId': appleUserId,
      'isMobileVerified': isMobileVerified,
      'productAccess': productAccess,
    };
  }
}
