class MostEnrolledResponse {
  List<MostEnrolledCourse>? response;

  MostEnrolledResponse({this.response});

  MostEnrolledResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <MostEnrolledCourse>[];
      json['response'].forEach((v) {
        response!.add(MostEnrolledCourse.fromJson(v));
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

class MostEnrolledCourse {
  int? id;
  String? name;
  String? description;
  String? slug;
  int? courseType;
  String? onexThumbnailUrl;
  String? twoxThumbnailUrl;
  String? threexThumbnailUrl;
  List<Certifier>? certifiers;
  // marketingTags is null in example, leaving it out for now or as dynamic
  List<dynamic>? marketingTags;

  MostEnrolledCourse({
    this.id,
    this.name,
    this.description,
    this.slug,
    this.courseType,
    this.onexThumbnailUrl,
    this.twoxThumbnailUrl,
    this.threexThumbnailUrl,
    this.certifiers,
    this.marketingTags,
  });

  MostEnrolledCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    slug = json['slug'];
    courseType = json['courseType'];
    onexThumbnailUrl = json['onexThumbnailUrl'];
    twoxThumbnailUrl = json['twoxThumbnailUrl'];
    threexThumbnailUrl = json['threexThumbnailUrl'];
    if (json['certifiers'] != null) {
      certifiers = <Certifier>[];
      json['certifiers'].forEach((v) {
        certifiers!.add(Certifier.fromJson(v));
      });
    }
    // marketingTags logic if needed
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['slug'] = slug;
    data['courseType'] = courseType;
    data['onexThumbnailUrl'] = onexThumbnailUrl;
    data['twoxThumbnailUrl'] = twoxThumbnailUrl;
    data['threexThumbnailUrl'] = threexThumbnailUrl;
    if (certifiers != null) {
      data['certifiers'] = certifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Certifier {
  String? name;
  int? id;
  String? description;
  String? logoUrl;
  int? courseId;

  Certifier({
    this.name,
    this.id,
    this.description,
    this.logoUrl,
    this.courseId,
  });

  Certifier.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    description = json['description'];
    logoUrl = json['logoUrl'];
    courseId = json['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['description'] = description;
    data['logoUrl'] = logoUrl;
    data['courseId'] = courseId;
    return data;
  }
}
