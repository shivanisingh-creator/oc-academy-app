class GlobalPartnersResponse {
  final List<String>? response;

  GlobalPartnersResponse({this.response});

  factory GlobalPartnersResponse.fromJson(Map<String, dynamic> json) {
    return GlobalPartnersResponse(
      response: json['response'] != null
          ? List<String>.from(json['response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'response': response};
  }
}
