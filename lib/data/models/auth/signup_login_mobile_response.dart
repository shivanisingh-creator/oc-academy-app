class SignupLoginMobileResponse {
  final String? response;

  SignupLoginMobileResponse({this.response});

  factory SignupLoginMobileResponse.fromJson(Map<String, dynamic> json) {
    return SignupLoginMobileResponse(
      response: json['response'],
    );
  }
}
