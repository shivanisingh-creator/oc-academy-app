class SpecialtyResponse {
  List<Specialty>? response;

  SpecialtyResponse({this.response});

  SpecialtyResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Specialty>[];
      json['response'].forEach((v) {
        response!.add(Specialty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialty {
  int? specialityId;
  String? specialityName;
  String? specialityIcon;
  int? coursesCount;
  int? ocId;
  String? specialityImageUrl;
  String? description;
  String? seoLinks;
  String? metaTitle;
  String? metaDescription;

  Specialty({
    this.specialityId,
    this.specialityName,
    this.specialityIcon,
    this.coursesCount,
    this.ocId,
    this.specialityImageUrl,
    this.description,
    this.seoLinks,
    this.metaTitle,
    this.metaDescription,
  });

  Specialty.fromJson(Map<String, dynamic> json) {
    specialityId = json['specialityId'];
    specialityName = json['specialityName'];
    specialityIcon = json['specialityIcon'];
    coursesCount = json['coursesCount'];
    ocId = json['ocId'];
    specialityImageUrl = json['specialityImageUrl'];
    description = json['description'];
    seoLinks = json['seoLinks'];
    metaTitle = json['metaTitle'];
    metaDescription = json['metaDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialityId'] = specialityId;
    data['specialityName'] = specialityName;
    data['specialityIcon'] = specialityIcon;
    data['coursesCount'] = coursesCount;
    data['ocId'] = ocId;
    data['specialityImageUrl'] = specialityImageUrl;
    data['description'] = description;
    data['seoLinks'] = seoLinks;
    data['metaTitle'] = metaTitle;
    data['metaDescription'] = metaDescription;
    return data;
  }
}
