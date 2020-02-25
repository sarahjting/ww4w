import 'package:http/http.dart' as http;
import 'dart:convert';
import './Manager.dart';
import '../models/Waifu.dart';

class WaifuManager extends Manager {
  Future<Map<String, dynamic>> list() async {
    http.Response res = await this.post("waifus/list");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    if (parsed["Waifus"] != null)
      parsed["Waifus"] =
          parsed["Waifus"].map<Waifu>((json) => Waifu.fromJson(json)).toList();
    return parsed;
  }

  Future<Map<String, dynamic>> gacha() async {
    http.Response res = await this.post("waifus/gacha");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    parsed["Waifu"] = Waifu.fromJson(parsed["Waifu"]);
    return parsed;
  }
}
