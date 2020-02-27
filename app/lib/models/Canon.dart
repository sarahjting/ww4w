class Canon {
  final int malId;
  final String title;
  final String url;
  final String imageUrl;
  final String malType;

  Canon({this.malType, this.malId, this.title, this.imageUrl, this.url});

  factory Canon.fromMAL(String malType, Map<String, dynamic> json) {
    if (json == null) return null;
    return Canon(
      malType: malType,
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      url: json['url'],
    );
  }
  factory Canon.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Canon(
      malType: json["MALType"],
      malId: json['MALID'],
      title: json['Title'],
      url: json['URL'],
      imageUrl: json['ImageURL'],
    );
  }
}
