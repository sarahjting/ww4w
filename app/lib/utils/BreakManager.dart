import 'package:http/http.dart' as http;
import 'dart:convert';
import './Manager.dart';
import '../models/Break.dart';

class BreakManager extends Manager {
  Future<Break> current() async {
    String currentString = await getLocalStorage('break');
    if (currentString != null) {
      return new Break(createdAt: DateTime.parse(currentString));
    }
    return null;
  }

  Future<Break> start() async {
    Break newBreak = new Break(createdAt: DateTime.now());
    setLocalStorage('break', newBreak.createdAt.toString());
    return newBreak;
  }

  void cancel() async {
    setLocalStorage('break', null);
  }
}
