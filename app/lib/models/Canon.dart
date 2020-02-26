class Canon {
  final int malId;
  final String title;
  final String imageUrl;
  final String type;

  Canon({this.type, this.malId, this.title, this.imageUrl});

  factory Canon.fromJson(type, Map<String, dynamic> json) {
    if (json == null) return null;
    return Canon(
      type: type,
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
    );
  }
}
