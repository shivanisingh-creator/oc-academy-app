class RecentActivity {
  final int id;
  final String name;
  final String status;
  final int widgetType;
  final int chapterType;
  final int lastVisit;
  final String courseName;
  final int courseStatus;
  final String slug;
  final bool isCourseAccessible;
  final int? subjectId; // Optional as it was missing in some items in example

  RecentActivity({
    required this.id,
    required this.name,
    required this.status,
    required this.widgetType,
    required this.chapterType,
    required this.lastVisit,
    required this.courseName,
    required this.courseStatus,
    required this.slug,
    required this.isCourseAccessible,
    this.subjectId,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      widgetType: json['widgetType'] ?? 0,
      chapterType: json['chapterType'] ?? 0,
      lastVisit: json['lastVisit'] ?? 0,
      courseName: json['courseName'] ?? '',
      courseStatus: json['courseStatus'] ?? 0,
      slug: json['slug'] ?? '',
      isCourseAccessible: json['isCourseAccessible'] ?? false,
      subjectId: json['subjectId'],
    );
  }
}
