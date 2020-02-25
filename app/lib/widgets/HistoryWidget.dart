import 'package:flutter/material.dart';
import 'Loading.dart';
import '../models/Cycle.dart';
import '../utils/CycleManager.dart';
import 'package:intl/intl.dart';

class HistoryWidget extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryWidget> {
  bool _isLoading = true;
  List<Cycle> _cycles;
  CycleManager _manager;

  void _load() async {
    Map<String, dynamic> res = await _manager.list();
    setState(() {
      _cycles = res["Cycles"];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _manager = new CycleManager();
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
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child:
            Text("TODAY'S CYCLES", style: Theme.of(context).textTheme.button),
      ),
      _buildTable(_cycles.where((x) => x.isToday()).toList()),
      Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Text("THIS WEEK'S CYCLES",
            style: Theme.of(context).textTheme.button),
      ),
      _buildTable(_cycles.where((x) => !x.isToday()).toList())
    ]);
  }

  Widget _buildTable(cycles) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey[300], width: 1.0),
        top: BorderSide(color: Colors.black, width: 1.0),
        bottom: BorderSide(color: Colors.black, width: 1.0),
      ),
      children: cycles.map<TableRow>((cycle) {
        return TableRow(children: <Widget>[
          _buildTableCell(
              DateFormat("yyyy-MM-dd HH:mm:ss").format(cycle.createdAt)),
          _buildTableCell(cycle.tag),
        ]);
      }).toList(),
    );
  }

  Widget _buildTableCell(text) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(text),
    );
  }
}
