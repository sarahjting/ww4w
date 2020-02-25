import 'package:flutter/material.dart';

import 'Loading.dart';
import 'dart:async';
import '../models/Waifu.dart';
import '../utils/WaifuManager.dart';

class GachaWidget extends StatefulWidget {
  var _setGems, _getGems;
  GachaWidget(this._setGems, this._getGems);

  @override
  _GachaState createState() => _GachaState(_setGems, _getGems);
}

class _GachaState extends State<GachaWidget> {
  bool _isLoading = false;
  WaifuManager _manager;
  var _setGems, _getGems, _res;

  _GachaState(this._setGems, this._getGems);

  void _handleGacha(context) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _manager.gacha();
    setState(() => _isLoading = false);
    if (res["Status"]) {
      _popDialog(context, waifu: res["Waifu"]);
      _setGems(res["Gems"]);
    } else {
      _popDialog(context, error: res["Error"]);
    }
  }

  void _popDialog(BuildContext context, {Waifu waifu, String error}) async {
    final ThemeData theme = Theme.of(context);
    var content;

    if (waifu != null && error == null) {
      content = AlertDialog(
        content: Container(
          height: 418,
          child: Column(children: <Widget>[
            Image.network(
              waifu.imageUrl,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("You've pulled " + waifu.name + "!"),
            ),
          ]),
        ),
        actions: [
          RaisedButton(
            child: Text("Pull Again"),
            onPressed: () {
              Navigator.pop(context);
              _handleGacha(context);
            },
          ),
        ],
      );
    } else {
      content = AlertDialog(
        content: ListTile(
          title: Text(error),
        ),
      );
    }

    _res = await showDialog(
      context: context,
      builder: (context) => content,
    );
  }

  @override
  void initState() {
    super.initState();
    _manager = new WaifuManager();
  }

  @override
  Widget build(BuildContext context) {
    if (this._isLoading)
      return Loading();
    else
      return _build(context);
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.star),
            Text("You have " + _getGems().toString() + " gems."),
            RaisedButton(
                onPressed: () {
                  _handleGacha(context);
                },
                child: Text("Boom"))
          ],
        ),
      ),
    );
  }
}
