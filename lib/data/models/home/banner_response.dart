class BannerResponse {
  final List<Banner>? response;

  BannerResponse({this.response});

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      response: json['response'] != null
          ? (json['response'] as List).map((i) => Banner.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'response': response?.map((i) => i.toJson()).toList()};
  }
}

class Banner {
  final int? id;
  final int? displayOrder;
  final String? title;
  final int? status;
  final bool? onlyForLoggedInUser;
  final int? createdDate;
  final String? bannerLink;
  final int? startDate;
  final int? endDate;
  final String? contentWebUrl;
  final String? contentAppUrl;
  final int? countryVisibleType;
  final int? specialityVisibleType;
  final dynamic specialityIds;
  final dynamic countryIds;

  Banner({
    this.id,
    this.displayOrder,
    this.title,
    this.status,
    this.onlyForLoggedInUser,
    this.createdDate,
    this.bannerLink,
    this.startDate,
    this.endDate,
    this.contentWebUrl,
    this.contentAppUrl,
    this.countryVisibleType,
    this.specialityVisibleType,
    this.specialityIds,
    this.countryIds,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      displayOrder: json['displayOrder'],
      title: json['title'],
      status: json['status'],
      onlyForLoggedInUser: json['onlyForLoggedInUser'],
      createdDate: json['createdDate'],
      bannerLink: json['bannerLink'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      contentWebUrl: json['contentWebUrl'],
      contentAppUrl: json['contentAppUrl'],
      countryVisibleType: json['countryVisibleType'],
      specialityVisibleType: json['specialityVisibleType'],
      specialityIds: json['specialityIds'],
      countryIds: json['countryIds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayOrder': displayOrder,
      'title': title,
      'status': status,
      'onlyForLoggedInUser': onlyForLoggedInUser,
      'createdDate': createdDate,
      'bannerLink': bannerLink,
      'startDate': startDate,
      'endDate': endDate,
      'contentWebUrl': contentWebUrl,
      'contentAppUrl': contentAppUrl,
      'countryVisibleType': countryVisibleType,
      'specialityVisibleType': specialityVisibleType,
      'specialityIds': specialityIds,
      'countryIds': countryIds,
    };
  }
}
