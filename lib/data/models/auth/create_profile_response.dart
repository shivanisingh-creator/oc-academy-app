import 'package:json_annotation/json_annotation.dart';

part 'create_profile_response.g.dart';

@JsonSerializable()
class CreateProfileResponse {
  final Response? response;

  CreateProfileResponse({this.response});

  factory CreateProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProfileResponseToJson(this);
}

@JsonSerializable()
class Response {
  final String? accessToken;

  Response({this.accessToken});

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
