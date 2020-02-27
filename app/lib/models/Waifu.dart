class Waifu {
  final int malId;
  final String name;
  final String url;
  final String imageUrl;
  final String canon;
  final String canonUrl;

  Waifu({
    this.malId,
    this.name,
    this.url,
    this.imageUrl,
    this.canon,
    this.canonUrl,
  });

  factory Waifu.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json["MALID"] == 0) return null;
    return Waifu(
      malId: json['MALID'],
      name: json['Name'],
      url: json['URL'],
      imageUrl: json['ImageURL'],
      canon: json['Canon'],
      canonUrl: json['CanonURL'],
    );
  }
}
