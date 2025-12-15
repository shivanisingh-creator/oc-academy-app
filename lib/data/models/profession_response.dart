class ProfessionResponse {
  final List<Profession> professions;

  ProfessionResponse({required this.professions});

  factory ProfessionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['response'] as List<dynamic>?;
    List<Profession> professionsList = [];
    if (list != null) {
      professionsList = list
          .map((e) => Profession.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return ProfessionResponse(
      professions: professionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': professions.map((e) => e.toJson()).toList(),
    };
  }
}

class Profession {
  final int id;
  final String name;
  final bool status;

  Profession({required this.id, required this.name, required this.status});

  factory Profession.fromJson(Map<String, dynamic> json) => Profession(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };
}
