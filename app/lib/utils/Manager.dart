import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:random_string/random_string.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class Manager {
  final LocalStorage storage = new LocalStorage('storage');

  Future<http.Response> post(url, [body]) async {
    if (body == null) body = {};
    if (storage.getItem("device-id") == null) {
      storage.setItem("device-id", await getDeviceId());
    }
    String deviceId = storage.getItem("device-id");
    body["id"] = deviceId;
    return http.post(
      DotEnv().env['SERVER_ROOT'] + url,
      body: json.encode(body),
    );
  }

  Future<http.Response> get(url) async {
    return http.get(
      DotEnv().env['SERVER_ROOT'] + url,
    );
  }

  //https://stackoverflow.com/questions/45031499/how-to-get-unique-device-id-in-flutter
  Future<String> getDeviceId() async {
    String identifier = "1";
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
