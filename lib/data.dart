class DatabaseMusic {
  String name = "";
  String year = "";
  String link = "";
  String image = "";

  String get getName {
    return name;
  }

  set setName(String name) {
    name = name;
  }

  //DatabaseMusic({required this.name, required this.year, required this.link});
  DatabaseMusic({String? name, String? year, String? link, String? image});
  factory DatabaseMusic.fromJson(dynamic json) {
    return DatabaseMusic(
        name: "${json['name']}",
        year: "${json['year']}",
        link: "${json['link']}",
        image: "${json['image']}");
  }
  Map toJson() => {"name": name, "year": year, "link": link, "image": image};
}
