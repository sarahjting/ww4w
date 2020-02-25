import 'package:flutter/material.dart';

import 'Loading.dart';
import 'dart:async';
import '../models/Cycle.dart';
import '../utils/CycleManager.dart';

class TimerWidget extends StatefulWidget {
  var _setGems;
  TimerWidget(this._setGems);

  @override
  _TimerState createState() => _TimerState(_setGems);
}

class _TimerState extends State<TimerWidget> {
  bool _isLoading = true;
  Cycle _currentCycle;
  CycleManager _manager;
  int _secondsLeft;
  var _setGems;
  var _timer;

  _TimerState(this._setGems);

  void _handleStart(context, String tag) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _manager.start(tag: tag);
    if (res["Status"]) {
      _popSnackbar(context, "Cycle started. Time to work!");
      setState(() {
        _currentCycle = res["Cycle"];
        _isLoading = false;
        _updateCountdown();
      });
    } else {
      _popSnackbar(context, "Error: " + res["Error"]);
    }
  }

  void _handleEnd(context) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _manager.end();
    if (res["Status"]) {
      _popSnackbar(context, "Great work! You've gained a gem.");
      _setGems(res["Gems"]);
      setState(() {
        _currentCycle = null;
        _isLoading = false;
      });
    } else {
      _popSnackbar(context, "Error: " + res["Error"]);
    }
  }

  void _popSnackbar(context, text) async {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _updateCountdown() {
    if (_currentCycle == null) return;
    setState(() => _secondsLeft = _currentCycle.secondsLeft());
    _timer = Timer(Duration(seconds: 1), _updateCountdown);
  }

  void _loadTimer() async {
    Map<String, dynamic> res = await _manager.current();
    _setGems(res["Gems"]);
    setState(() {
      if (res["Cycle"] != null) {
        _currentCycle = res["Cycle"];
      }
      _isLoading = false;
    });
    _updateCountdown();
  }

  @override
  void initState() {
    super.initState();
    _manager = new CycleManager();
    _loadTimer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._isLoading)
      return Loading();
    else if (this._currentCycle != null)
      return _buildActive(context);
    else
      return _buildInactive(context);
  }

  Widget _buildInactive(BuildContext context) {
    final tagController = TextEditingController();
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task',
              ),
            ),
            RaisedButton(
              onPressed: () {
                _handleStart(context, tagController.text);
              },
              child: Text('Start Work'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActive(BuildContext context) {
    List<Widget> widgets = <Widget>[
      Text("Work cycle in progress..."),
      Text(_secondsLeft.toString() + "s"),
    ];
    if (_secondsLeft == 0) {
      widgets.add(RaisedButton(
        onPressed: () {
          _handleEnd(context);
        },
        child: Text("Complete Cycle"),
      ));
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }
}
