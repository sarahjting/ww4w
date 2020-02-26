import 'package:http/http.dart' as http;
import 'dart:convert';
import './Manager.dart';
import '../models/Cycle.dart';

class CycleManager extends Manager {
  Future<Map<String, dynamic>> list() async {
    http.Response res = await this.post("cycles/list");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    if (parsed["Cycles"] != null)
      parsed["Cycles"] =
          parsed["Cycles"].map<Cycle>((json) => Cycle.fromJson(json)).toList();
    return parsed;
  }

  Future<List<String>> tags() async {
    http.Response res = await this.post("cycles/tags");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    List<String> tags;
    if (parsed["Tags"] == null) {
      tags = List<String>();
    } else {
      tags = parsed["Tags"].map<String>((x) => x as String).toList();
    }
    return tags;
  }

  Future<Map<String, dynamic>> current() async {
    http.Response res = await this.post("cycles/current");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    parsed["Cycle"] = Cycle.fromJson(parsed["Cycle"]);
    return parsed;
  }

  Future<Map<String, dynamic>> start({tag}) async {
    http.Response res = await this.post("cycles/start", {"tag": tag});
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    parsed["Cycle"] = Cycle.fromJson(parsed["Cycle"]);
    return parsed;
  }

  Future<Map<String, dynamic>> end() async {
    http.Response res = await this.post("cycles/end");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    return parsed;
  }

  Future<Map<String, dynamic>> cancel() async {
    http.Response res = await this.post("cycles/cancel");
    final parsed = json.decode(res.body) as Map<String, dynamic>;
    return parsed;
  }
}
