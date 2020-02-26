import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Canon.dart';
import './Manager.dart';

class CanonManager extends Manager {
  Future<List<Canon>> list({String type, String search}) async {
    http.Response res = await this.post("canons/list");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    if (parsed["Canons"] != null)
      parsed["Canons"] =
          parsed["Canons"].map<Canon>((json) => Canon.fromJson(json)).toList();
    return parsed["Canons"];
  }

  Future<List<Canon>> top({String type, String search}) async {
    if (type != 'anime' && type != 'manga') return [] as List<Canon>;
    String url = "", key = "results";
    if (search != null && search != "") {
      url = "https://api.jikan.moe/v3/search/" +
          type +
          "?q=" +
          Uri.encodeFull(search);
    } else {
      url = "https://api.jikan.moe/v3/top/" + type;
      key = "top";
    }

    http.Response res = await http.get(url);
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    return parsed[key].map<Canon>((json) => Canon.fromMAL(type, json)).toList()
        as List<Canon>;
  }

  Future<void> add({String malType, double malId}) async {
    await this.post("canons/add", {"mal_type": malType, "mal_id": malId});
  }

  Future<void> remove({String malType, double malId}) async {
    await this.post("canons/remove", {"mal_type": malType, "mal_id": malId});
  }
}
