class CourseProgressResponse {
  List<CourseCategory>? response;

  CourseProgressResponse({this.response});

  CourseProgressResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <CourseCategory>[];
      json['response'].forEach((v) {
        response!.add(CourseCategory.fromJson(v));
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

class CourseCategory {
  String? title;
  int? courseType;
  List<CourseProgressDetail>? courseProgressDetail;

  CourseCategory({this.title, this.courseType, this.courseProgressDetail});

  CourseCategory.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    courseType = json['courseType'];
    if (json['courseProgressDetail'] != null) {
      courseProgressDetail = <CourseProgressDetail>[];
      json['courseProgressDetail'].forEach((v) {
        courseProgressDetail!.add(CourseProgressDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['courseType'] = courseType;
    if (courseProgressDetail != null) {
      data['courseProgressDetail'] = courseProgressDetail!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class CourseProgressDetail {
  int? id;
  String? name;
  String? progressTitle;
  String? progress;
  String? totalTimeSpent;
  int? status;
  List<DetailedProgress>? detailedProgress;

  CourseProgressDetail({
    this.id,
    this.name,
    this.progressTitle,
    this.progress,
    this.totalTimeSpent,
    this.status,
    this.detailedProgress,
  });

  CourseProgressDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    progressTitle = json['progressTitle'];
    progress = json['progress'];
    totalTimeSpent = json['totalTimeSpent'];
    status = json['status'];
    if (json['detailedProgress'] != null) {
      detailedProgress = <DetailedProgress>[];
      json['detailedProgress'].forEach((v) {
        detailedProgress!.add(DetailedProgress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['progressTitle'] = progressTitle;
    data['progress'] = progress;
    data['totalTimeSpent'] = totalTimeSpent;
    data['status'] = status;
    if (detailedProgress != null) {
      data['detailedProgress'] = detailedProgress!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class DetailedProgress {
  int? id;
  String? name;
  String? progressTitle;
  String? progress;
  String? totalTimeSpent;
  int? progressPercent;

  DetailedProgress({
    this.id,
    this.name,
    this.progressTitle,
    this.progress,
    this.totalTimeSpent,
    this.progressPercent,
  });

  DetailedProgress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    progressTitle = json['progressTitle'];
    progress = json['progress'];
    totalTimeSpent = json['totalTimeSpent'];
    progressPercent = json['progressPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['progressTitle'] = progressTitle;
    data['progress'] = progress;
    data['totalTimeSpent'] = totalTimeSpent;
    data['progressPercent'] = progressPercent;
    return data;
  }
}
