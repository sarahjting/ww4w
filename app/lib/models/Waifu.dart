class Waifu {
  final int malId;
  final String name;
  final String url;
  final String imageUrl;

  Waifu({this.malId, this.name, this.url, this.imageUrl});

  factory Waifu.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json["MALID"] == 0) return null;
    return Waifu(
      malId: json['MALID'],
      name: json['Name'],
      url: json['URL'],
      imageUrl: json['ImageURL'],
    );
  }
}
