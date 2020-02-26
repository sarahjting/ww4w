import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Canon.dart';

class CanonManager {
  Future<List<Canon>> list(String type, String search) async {
    if (type != 'anime' && type != 'manga') return [] as List<Canon>;
    http.Response res = await http.get("https://api.jikan.moe/v3/search/" +
        type +
        "?q=" +
        Uri.encodeFull(search));
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    return parsed["results"]
        .map<Canon>((json) => Canon.fromJson(type, json))
        .toList();
  }

  Future<List<Canon>> top(String type, String search) async {
    if (type != 'anime' && type != 'manga') return [] as List<Canon>;
    http.Response res = await http.get("https://api.jikan.moe/v3/top/" + type);
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    return parsed["top"]
        .map<Canon>((json) => Canon.fromJson(type, json))
        .toList();
  }
}
