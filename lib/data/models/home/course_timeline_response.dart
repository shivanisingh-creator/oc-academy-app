class CourseTimelineResponse {
  TimelineData? response;

  CourseTimelineResponse({this.response});

  CourseTimelineResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? TimelineData.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class TimelineData {
  int? id;
  String? name;
  List<TimelineCourse>? courses;

  TimelineData({this.id, this.name, this.courses});

  TimelineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['courses'] != null) {
      courses = <TimelineCourse>[];
      json['courses'].forEach((v) {
        courses!.add(TimelineCourse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimelineCourse {
  int? id;
  String? name;
  String? slug;
  List<TimelineSubject>? subjects;
  List<TimelineQuiz>? masterQuiz;
  List<dynamic>? liveEvents;

  TimelineCourse({
    this.id,
    this.name,
    this.slug,
    this.subjects,
    this.masterQuiz,
    this.liveEvents,
  });

  TimelineCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['subjects'] != null) {
      subjects = <TimelineSubject>[];
      json['subjects'].forEach((v) {
        subjects!.add(TimelineSubject.fromJson(v));
      });
    }
    if (json['masterQuiz'] != null) {
      masterQuiz = <TimelineQuiz>[];
      json['masterQuiz'].forEach((v) {
        masterQuiz!.add(TimelineQuiz.fromJson(v));
      });
    }
    liveEvents = json['liveEvents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    if (masterQuiz != null) {
      data['masterQuiz'] = masterQuiz!.map((v) => v.toJson()).toList();
    }
    data['liveEvents'] = liveEvents;
    return data;
  }
}

class TimelineSubject {
  int? id;
  String? name;
  int? courseId;
  int? displayOrder;
  List<TimelineModule>? modules;

  TimelineSubject({
    this.id,
    this.name,
    this.courseId,
    this.displayOrder,
    this.modules,
  });

  TimelineSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    courseId = json['courseId'];
    displayOrder = json['displayOrder'];
    if (json['modules'] != null) {
      modules = <TimelineModule>[];
      json['modules'].forEach((v) {
        modules!.add(TimelineModule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['courseId'] = courseId;
    data['displayOrder'] = displayOrder;
    if (modules != null) {
      data['modules'] = modules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimelineModule {
  int? id;
  String? name;
  int? courseId;
  int? subjectId;
  int? displayOrder;
  List<TimelineChapter>? chapters;
  List<TimelineQuiz>? quiz;

  TimelineModule({
    this.id,
    this.name,
    this.courseId,
    this.subjectId,
    this.displayOrder,
    this.chapters,
    this.quiz,
  });

  TimelineModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    courseId = json['courseId'];
    subjectId = json['subjectId'];
    displayOrder = json['displayOrder'];
    if (json['chapters'] != null) {
      chapters = <TimelineChapter>[];
      json['chapters'].forEach((v) {
        chapters!.add(TimelineChapter.fromJson(v));
      });
    }
    if (json['quiz'] != null) {
      quiz = <TimelineQuiz>[];
      json['quiz'].forEach((v) {
        quiz!.add(TimelineQuiz.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['courseId'] = courseId;
    data['subjectId'] = subjectId;
    data['displayOrder'] = displayOrder;
    if (chapters != null) {
      data['chapters'] = chapters!.map((v) => v.toJson()).toList();
    }
    if (quiz != null) {
      data['quiz'] = quiz!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimelineChapter {
  int? id;
  String? name;
  int? moduleId;
  int? subjectId;
  int? chapterType;
  int? chapterStatus;

  TimelineChapter({
    this.id,
    this.name,
    this.moduleId,
    this.subjectId,
    this.chapterType,
    this.chapterStatus,
  });

  TimelineChapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    moduleId = json['moduleId'];
    subjectId = json['subjectId'];
    chapterType = json['chapterType'];
    chapterStatus = json['chapterStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['moduleId'] = moduleId;
    data['subjectId'] = subjectId;
    data['chapterType'] = chapterType;
    data['chapterStatus'] = chapterStatus;
    return data;
  }
}

class TimelineQuiz {
  int? id;
  String? name;
  int? quizStatus;

  TimelineQuiz({this.id, this.name, this.quizStatus});

  TimelineQuiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quizStatus = json['quizStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['quizStatus'] = quizStatus;
    return data;
  }
}
