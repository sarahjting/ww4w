import 'package:flutter/material.dart';
import 'Loading.dart';
import '../models/Canon.dart';
import '../utils/CanonManager.dart';
import 'dart:async';
import './Loading.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  bool _isLoading = true;
  List<Canon> _canons;
  CanonManager _manager;

  void _load() async {
    setState(() => _isLoading = true);
    List<Canon> res = await _manager.list();
    setState(() {
      _canons = res;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _manager = new CanonManager();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (this._isLoading)
      return Loading();
    else
      return _build(context);
  }

  Widget _build(BuildContext context) {
    List<Widget> children = <Widget>[
      _buildBanner(context),
    ];
    if (_canons == null || _canons.length == 0) {
      children.add(
        Center(
          child: Padding(
              padding: EdgeInsets.all(50.0),
              child: Text("You haven't added any anime or manga yet!")),
        ),
      );
    } else {
      _canons.forEach((canon) {
        children.add(Card(
          child: ListTile(
              leading: canon.imageUrl != null
                  ? Image.network(canon.imageUrl)
                  : Icon(Icons.image),
              title: Text(canon.title),
              trailing: Icon(Icons.remove_circle),
              onTap: () async {
                setState(() => _isLoading = true);
                await _manager.remove(
                  malType: canon.malType,
                  malId: canon.malId,
                );
                _load();
              }),
        ));
      });
    }
    return ListView(children: children);
  }

  Widget _buildBanner(context) {
    return MaterialBanner(
      content: Text(""),
      actions: [
        RaisedButton(
          child: Text("+ Anime"),
          color: Colors.pink,
          onPressed: () => _popDialog("anime"),
        ),
        RaisedButton(
          child: Text("+ Manga"),
          color: Colors.pink,
          onPressed: () => _popDialog("manga"),
        ),
      ],
    );
  }

  void _popDialog(malType) {
    setState(() {
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => _SelectorWidget(malType, _load),
          fullscreenDialog: true,
        ),
      );
    });
  }
}

class _SelectorWidget extends StatefulWidget {
  String _malType;
  var _reload;
  _SelectorWidget(this._malType, this._reload);

  @override
  _SelectorState createState() => _SelectorState(_malType, _reload);
}

class _SelectorState extends State<_SelectorWidget> {
  String _malType;
  List<Canon> _canons;
  CanonManager _manager;
  var _reload;
  bool _isLoading = true;
  var _searchTimeout;

  _SelectorState(this._malType, this._reload);

  void _handleUpdateSearch(search) => _load(search);

  void _load([String search]) async {
    setState(() => _isLoading = true);
    List<Canon> res = await _manager.top(type: _malType, search: search);
    setState(() {
      _canons = res;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _manager = new CanonManager();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    children.add(_buildSearchBar(context));
    if (_isLoading) {
      children.add(Loading());
    } else {
      _canons.forEach((canon) => children.add(_buildRow(context, canon)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Select " + _malType),
      ),
      body: Center(
        child: ListView(children: children),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_searchTimeout != null) {
      _searchTimeout.cancel();
      _searchTimeout = null;
    }
  }

  Widget _buildRow(BuildContext context, Canon canon) {
    return Card(
      child: ListTile(
          leading: Image.network(canon.imageUrl),
          title: Text(canon.title),
          trailing: Icon(Icons.add_circle),
          onTap: () async {
            setState(() => _isLoading = true);
            await _manager.add(malType: _malType, malId: canon.malId);
            Navigator.pop(context);
            _reload();
          }),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            contentPadding: EdgeInsets.all(10.0),
          ),
          onChanged: (item) {
            setState(() {
              if (_searchTimeout != null) _searchTimeout.cancel();
              _searchTimeout =
                  Timer(Duration(seconds: 1), () => _handleUpdateSearch(item));
            });
          },
        ),
      ),
    );
  }
}
