class Waifu {
  final int malId;
  final String name;
  final String url;
  final String imageUrl;

  Waifu({this.malId, this.name, this.url, this.imageUrl});

  factory Waifu.fromJson(Map<String, dynamic> json) {
    return Waifu(
      malId: json['MALID'],
      name: json['Name'],
      url: json['URL'],
      imageUrl: json['ImageURL'],
    );
  }
}
