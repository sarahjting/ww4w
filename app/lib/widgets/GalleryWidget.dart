import 'package:flutter/material.dart';

import 'Loading.dart';
import '../models/Waifu.dart';
import '../utils/WaifuManager.dart';

class GalleryWidget extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<GalleryWidget> {
  bool _isLoading = true;
  List<Waifu> _waifus;
  WaifuManager _manager;

  void _load() async {
    Map<String, dynamic> res = await _manager.list();
    setState(() {
      _waifus = res["Waifus"];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _manager = new WaifuManager();
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
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: _waifus.map<Widget>((waifu) {
        return GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(waifu.name),
              ),
            ),
          ),
          child: Image.network(waifu.imageUrl),
        );
      }).toList(),
    );
  }
}
