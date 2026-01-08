class LiveEventResponse {
  LiveEvent? response;

  LiveEventResponse({this.response});

  LiveEventResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? LiveEvent.fromJson(json['response'])
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

class LiveEvent {
  int? id;
  String? name;
  String? description;
  String? joinLink;
  int? launchDate;
  int? startTime;
  int? endTime;
  String? eventThumbnailUrl;
  String? recordedContentUrl;
  int? liveEventBatchId;
  String? liveEventBatchName;
  int? courseId;
  String? courseSlug;
  bool? hasSubjects;

  LiveEvent({
    this.id,
    this.name,
    this.description,
    this.joinLink,
    this.launchDate,
    this.startTime,
    this.endTime,
    this.eventThumbnailUrl,
    this.recordedContentUrl,
    this.liveEventBatchId,
    this.liveEventBatchName,
    this.courseId,
    this.courseSlug,
    this.hasSubjects,
  });

  LiveEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    joinLink = json['joinLink'];
    launchDate = json['launchDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    eventThumbnailUrl = json['eventThumbnailUrl'];
    recordedContentUrl = json['recordedContentUrl'];
    liveEventBatchId = json['liveEventBatchId'];
    liveEventBatchName = json['liveEventBatchName'];
    courseId = json['courseId'];
    courseSlug = json['courseSlug'];
    hasSubjects = json['hasSubjects'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['joinLink'] = joinLink;
    data['launchDate'] = launchDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['eventThumbnailUrl'] = eventThumbnailUrl;
    data['recordedContentUrl'] = recordedContentUrl;
    data['liveEventBatchId'] = liveEventBatchId;
    data['liveEventBatchName'] = liveEventBatchName;
    data['courseId'] = courseId;
    data['courseSlug'] = courseSlug;
    data['hasSubjects'] = hasSubjects;
    return data;
  }
}
