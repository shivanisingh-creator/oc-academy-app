class BlogPostResponse {
  final int id;
  final String date;
  final BlogPostGuid guid;
  final String link;
  final BlogPostTitle title;
  final BlogPostContent content;
  final BlogPostExcerpt excerpt;
  final String? estimatedReadingTime; // Extracted from yoast_head_json
  final Map<String, dynamic>? yoastHeadJson;
  final List<String> class_list;

  BlogPostResponse({
    required this.id,
    required this.date,
    required this.guid,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    this.estimatedReadingTime,
    this.yoastHeadJson,
    required this.class_list,
  });

  factory BlogPostResponse.fromJson(Map<String, dynamic> json) {
    return BlogPostResponse(
      id: json['id'],
      date: json['date'],
      guid: BlogPostGuid.fromJson(json['guid']),
      link: json['link'],
      title: BlogPostTitle.fromJson(json['title']),
      content: BlogPostContent.fromJson(json['content']),
      excerpt: BlogPostExcerpt.fromJson(json['excerpt']),
      estimatedReadingTime:
          json['yoast_head_json']?['twitter_misc']?['Estimated reading time'],
      yoastHeadJson: json['yoast_head_json'],
      class_list: json['class_list'] != null
          ? List<String>.from(json['class_list'])
          : [],
    );
  }
}

class BlogPostGuid {
  final String rendered;

  BlogPostGuid({required this.rendered});

  factory BlogPostGuid.fromJson(Map<String, dynamic> json) {
    return BlogPostGuid(rendered: json['rendered']);
  }
}

class BlogPostTitle {
  final String rendered;

  BlogPostTitle({required this.rendered});

  factory BlogPostTitle.fromJson(Map<String, dynamic> json) {
    return BlogPostTitle(rendered: json['rendered']);
  }
}

class BlogPostContent {
  final String rendered;
  final bool protected;

  BlogPostContent({required this.rendered, required this.protected});

  factory BlogPostContent.fromJson(Map<String, dynamic> json) {
    return BlogPostContent(
      rendered: json['rendered'],
      protected: json['protected'],
    );
  }
}

class BlogPostExcerpt {
  final String rendered;
  final bool protected;

  BlogPostExcerpt({required this.rendered, required this.protected});

  factory BlogPostExcerpt.fromJson(Map<String, dynamic> json) {
    return BlogPostExcerpt(
      rendered: json['rendered'],
      protected: json['protected'],
    );
  }
}
