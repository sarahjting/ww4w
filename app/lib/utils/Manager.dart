import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Manager {
  String getUrl(String uri) {
    String root = DotEnv().env['SERVER_ROOT'];
    if (root == null) root = "/api/";
    return root + uri;
  }

  Future<http.Response> post(url, [body]) async {
    if (body == null) body = {};

    String deviceId = await getLocalStorage("device-id");
    if (deviceId == null) {
      deviceId = await _getDeviceId();
      setLocalStorage("device-id", deviceId);
    }
    body["id"] = deviceId;
    return http.post(
      getUrl(url),
      body: json.encode(body),
    );
  }

  Future<http.Response> get(url) async {
    return http.get(
      getUrl(url),
    );
  }

  Future<String> getLocalStorage(key) async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(key);
  }

  void setLocalStorage(key, value) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(key, value);
  }

  //https://stackoverflow.com/questions/45031499/how-to-get-unique-device-id-in-flutter
  Future<String> _getDeviceId() async {
    String identifier = randomAlphaNumeric(10);
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {} on UnsupportedError {}
    return identifier;
  }
}
