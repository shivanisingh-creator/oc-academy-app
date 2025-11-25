class SignupLoginGoogleRequest {
  final String accessToken;
  final String currentDevice;

  SignupLoginGoogleRequest({
    required this.accessToken,
    required this.currentDevice,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'currentDevice': currentDevice,
    };
  }
}
