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
    http.Response res =
        await this.post("canons/top", {"mal_type": type, "search": search});
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    if (parsed["Canons"] != null)
      parsed["Canons"] =
          parsed["Canons"].map<Canon>((json) => Canon.fromJson(json)).toList();
    return parsed["Canons"];
  }

  Future<void> add({String malType, int malId}) async {
    await this.post("canons/add", {"mal_type": malType, "mal_id": malId});
  }

  Future<void> remove({String malType, int malId}) async {
    await this.post("canons/remove", {"mal_type": malType, "mal_id": malId});
  }
}
