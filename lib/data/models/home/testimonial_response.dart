class TestimonialResponse {
  List<Testimonial>? response;

  TestimonialResponse({this.response});

  TestimonialResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Testimonial>[];
      json['response'].forEach((v) {
        response!.add(Testimonial.fromJson(v));
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

class Testimonial {
  int? id;
  String? name;
  String? title;
  String? description;
  String? contentUrl;
  bool? isVisible;
  int? displayOrder;

  Testimonial({
    this.id,
    this.name,
    this.title,
    this.description,
    this.contentUrl,
    this.isVisible,
    this.displayOrder,
  });

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    contentUrl = json['contentUrl'];
    isVisible = json['isVisible'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['description'] = description;
    data['contentUrl'] = contentUrl;
    data['isVisible'] = isVisible;
    data['displayOrder'] = displayOrder;
    return data;
  }
}
