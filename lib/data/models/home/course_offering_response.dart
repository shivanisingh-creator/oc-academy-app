class CourseOfferingResponse {
  List<CourseOffering>? response;

  CourseOfferingResponse({this.response});

  CourseOfferingResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <CourseOffering>[];
      json['response'].forEach((v) {
        response!.add(CourseOffering.fromJson(v));
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

class CourseOffering {
  String? media;
  String? title;
  List<String>? tags;
  String? description;
  int? courseType;

  CourseOffering({
    this.media,
    this.title,
    this.tags,
    this.description,
    this.courseType,
  });

  CourseOffering.fromJson(Map<String, dynamic> json) {
    media = json['media'];
    title = json['title'];
    tags = json['tags'].cast<String>();
    description = json['description'];
    courseType = json['courseType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media'] = media;
    data['title'] = title;
    data['tags'] = tags;
    data['description'] = description;
    data['courseType'] = courseType;
    return data;
  }
}
