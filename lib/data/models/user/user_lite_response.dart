class UserLiteResponse {
  final Response? response;

  UserLiteResponse({this.response});

  factory UserLiteResponse.fromJson(Map<String, dynamic> json) {
    return UserLiteResponse(
      response: json['response'] != null
          ? Response.fromJson(json['response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'response': response?.toJson()};
  }
}

class Response {
  final String? fullName;
  final int? userId;
  final String? email;
  final String? mobileNumber;
  final String? profilePic;
  final String? primaryRole;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? qualification;
  final String? specialitiesOfInterestIdsStr;
  final List<dynamic>? specialitiesOfInterestIds;
  final UserCountry? userCountry;
  final bool? isMobileVerified;
  final bool? isEmailVerified;
  final bool? isDocVerificationReq;
  final String? location;
  final List<String>? productAccess;

  Response({
    this.fullName,
    this.userId,
    this.email,
    this.mobileNumber,
    this.profilePic,
    this.primaryRole,
    this.title,
    this.firstName,
    this.lastName,
    this.qualification,
    this.specialitiesOfInterestIdsStr,
    this.specialitiesOfInterestIds,
    this.userCountry,
    this.isMobileVerified,
    this.isEmailVerified,
    this.isDocVerificationReq,
    this.location,
    this.productAccess,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      fullName: json['fullName'],
      userId: json['userId'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      profilePic: json['profilePic'],
      primaryRole: json['primaryRole'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      qualification: json['qualification'],
      specialitiesOfInterestIdsStr: json['specialitiesOfInterestIdsStr'],
      specialitiesOfInterestIds: json['specialitiesOfInterestIds'] ?? [],
      userCountry: json['userCountry'] != null
          ? UserCountry.fromJson(json['userCountry'])
          : null,
      isMobileVerified: json['isMobileVerified'],
      isEmailVerified: json['isEmailVerified'],
      isDocVerificationReq: json['isDocVerificationReq'],
      location: json['location'],
      productAccess: json['productAccess'] != null
          ? List<String>.from(json['productAccess'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'userId': userId,
      'email': email,
      'mobileNumber': mobileNumber,
      'profilePic': profilePic,
      'primaryRole': primaryRole,
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'qualification': qualification,
      'specialitiesOfInterestIdsStr': specialitiesOfInterestIdsStr,
      'specialitiesOfInterestIds': specialitiesOfInterestIds,
      'userCountry': userCountry?.toJson(),
      'isMobileVerified': isMobileVerified,
      'isEmailVerified': isEmailVerified,
      'isDocVerificationReq': isDocVerificationReq,
      'location': location,
      'productAccess': productAccess,
    };
  }
}

class UserCountry {
  final int? id;
  final String? code;
  final String? name;
  final int? phoneExtn;
  final String? flagUrl;
  final int? currencyType;

  UserCountry({
    this.id,
    this.code,
    this.name,
    this.phoneExtn,
    this.flagUrl,
    this.currencyType,
  });

  factory UserCountry.fromJson(Map<String, dynamic> json) {
    return UserCountry(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      phoneExtn: json['phoneExtn'],
      flagUrl: json['flagUrl'],
      currencyType: json['currencyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phoneExtn': phoneExtn,
      'flagUrl': flagUrl,
      'currencyType': currencyType,
    };
  }
}
