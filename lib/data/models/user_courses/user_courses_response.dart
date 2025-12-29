class UserCoursesResponse {
  int? status;
  String? message;
  int? timestamp;
  UserCoursesData? response;

  UserCoursesResponse({
    this.status,
    this.message,
    this.timestamp,
    this.response,
  });

  UserCoursesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    timestamp = json['timestamp'];
    response = json['response'] != null
        ? UserCoursesData.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['timestamp'] = timestamp;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class UserCoursesData {
  List<UserCourse>? completedCourses;
  List<UserCourse>? pendingCourses;

  UserCoursesData({this.completedCourses, this.pendingCourses});

  UserCoursesData.fromJson(Map<String, dynamic> json) {
    if (json['completedCourses'] != null) {
      completedCourses = <UserCourse>[];
      json['completedCourses'].forEach((v) {
        completedCourses!.add(UserCourse.fromJson(v));
      });
    }
    if (json['pendingCourses'] != null) {
      pendingCourses = <UserCourse>[];
      json['pendingCourses'].forEach((v) {
        pendingCourses!.add(UserCourse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completedCourses != null) {
      data['completedCourses'] = completedCourses!
          .map((v) => v.toJson())
          .toList();
    }
    if (pendingCourses != null) {
      data['pendingCourses'] = pendingCourses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserCourse {
  int? userId;
  int? courseId;
  String? courseSlug;
  String? courseName;
  String? courseDescription;
  int? progress;
  String? certificateUrl;
  String? courseDurationStr;
  String? issueDate;
  String? onexThumbnailUrl;
  String? twoxThumbnailUrl;
  String? threexThumbnailUrl;
  bool? isMoodle;
  int? startDate;
  int? endDate;
  int? userCourseStatus;
  bool? isUserDetailCaptured;
  int? enrollmentDate;

  UserCourse({
    this.userId,
    this.courseId,
    this.courseSlug,
    this.courseName,
    this.courseDescription,
    this.progress,
    this.certificateUrl,
    this.courseDurationStr,
    this.issueDate,
    this.onexThumbnailUrl,
    this.twoxThumbnailUrl,
    this.threexThumbnailUrl,
    this.isMoodle,
    this.startDate,
    this.endDate,
    this.userCourseStatus,
    this.isUserDetailCaptured,
    this.enrollmentDate,
  });

  UserCourse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    courseId = json['courseId'];
    courseSlug = json['courseSlug'];
    courseName = json['courseName'];
    courseDescription = json['courseDescription'];
    progress = json['progress'];
    certificateUrl = json['certificateUrl'];
    courseDurationStr = json['courseDurationStr']?.toString();
    issueDate = json['issueDate']?.toString();
    onexThumbnailUrl = json['onexThumbnailUrl'];
    twoxThumbnailUrl = json['twoxThumbnailUrl'];
    threexThumbnailUrl = json['threexThumbnailUrl'];
    isMoodle = json['isMoodle'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    userCourseStatus = json['userCourseStatus'];
    isUserDetailCaptured = json['isUserDetailCaptured'];
    enrollmentDate = json['enrollmentDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['courseId'] = courseId;
    data['courseSlug'] = courseSlug;
    data['courseName'] = courseName;
    data['courseDescription'] = courseDescription;
    data['progress'] = progress;
    data['certificateUrl'] = certificateUrl;
    data['courseDurationStr'] = courseDurationStr;
    data['issueDate'] = issueDate;
    data['onexThumbnailUrl'] = onexThumbnailUrl;
    data['twoxThumbnailUrl'] = twoxThumbnailUrl;
    data['threexThumbnailUrl'] = threexThumbnailUrl;
    data['isMoodle'] = isMoodle;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['userCourseStatus'] = userCourseStatus;
    data['isUserDetailCaptured'] = isUserDetailCaptured;
    data['enrollmentDate'] = enrollmentDate;
    return data;
  }
}
