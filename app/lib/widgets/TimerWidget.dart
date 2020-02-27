import 'package:flutter/material.dart';

import 'Loading.dart';
import 'dart:async';
import '../models/Cycle.dart';
import '../models/Break.dart';
import '../utils/CycleManager.dart';
import '../utils/BreakManager.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:math' show pi;

class TimerWidget extends StatefulWidget {
  var _setGems;
  TimerWidget(this._setGems);

  @override
  _TimerState createState() => _TimerState(_setGems);
}

class _TimerState extends State<TimerWidget> {
  bool _isLoading = true;
  Cycle _currentCycle;
  Break _currentBreak;
  CycleManager _cycleManager;
  BreakManager _breakManager;
  List<String> _tags;
  int _secondsLeft;
  var _setGems;
  var _timer;

  _TimerState(this._setGems);

  void _handleStartCycle(context, String tag) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _cycleManager.start(tag: tag);
    if (res["Status"]) {
      _popSnackbar(context, "Cycle started. Time to work!");
      setState(() {
        if (tag != '') _tags.add(tag);
        _currentCycle = res["Cycle"];
        _isLoading = false;
        _updateCountdown();
      });
    } else {
      _popSnackbar(context, "Error: " + res["Error"]);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleEndCycle(context) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _cycleManager.end();
    if (res["Status"]) {
      _popSnackbar(context, "Great work! You've gained a gem.");
      _setGems(res["Gems"]);
      setState(() async {
        _currentCycle = null;
        _currentBreak = await _breakManager.start();
        _isLoading = false;
      });
    } else {
      _popSnackbar(context, "Error: " + res["Error"]);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCancelCycle(context) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _cycleManager.cancel();
    if (res["Status"]) {
      _popSnackbar(context, "Work cycle has been canceled.");
      setState(() {
        _currentCycle = null;
        _isLoading = false;
      });
    } else {
      _popSnackbar(context, "Error: " + res["Error"]);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCancelBreak(context) async {
    _breakManager.cancel();
    _popSnackbar(context, "Break cycle has been canceled.");
    setState(() {
      _currentBreak = null;
      _isLoading = false;
    });
  }

  void _popSnackbar(context, text) async {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _updateCountdown() {
    if (_currentCycle == null && _currentBreak == null) return;
    if (_currentCycle != null) {
      setState(() => _secondsLeft = _currentCycle.secondsLeft());
    } else if (_currentBreak != null) {
      setState(() {
        _secondsLeft = _currentBreak.secondsLeft();
        if (_secondsLeft == 0) {
          _currentBreak = null;
          _breakManager.cancel();
        }
      });
      if (_secondsLeft == 0) return;
    }
    _timer = Timer(Duration(seconds: 1), _updateCountdown);
  }

  void _loadTimer() async {
    Map<String, dynamic> cycleRes = await _cycleManager.current();
    Break breakRes = await _breakManager.current();
    List<String> tags = await _cycleManager.tags();
    _setGems(cycleRes["Gems"]);
    setState(() {
      if (cycleRes["Cycle"] != null) {
        _currentCycle = cycleRes["Cycle"];
      } else if (breakRes != null) {
        _currentBreak = breakRes;
      }
      _tags = tags;
      _isLoading = false;
    });
    _updateCountdown();
  }

  @override
  void initState() {
    super.initState();
    _cycleManager = new CycleManager();
    _breakManager = new BreakManager();
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
    if (this._isLoading) {
      return Loading();
    } else if (this._currentCycle != null) {
      return _buildActive(
        context,
        countdown: this._currentCycle.countDowner(),
        progress: this._currentCycle.progress(),
        tag: this._currentCycle.tag,
        completeButton: this._secondsLeft == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: RaisedButton(
                  onPressed: () => _handleEndCycle(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      "Complete Cycle",
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                  textColor: Colors.white,
                  color: Colors.pink,
                ),
              )
            : null,
        cancelButton: RaisedButton(
          onPressed: () => _handleCancelCycle(context),
          child: Text("Cancel", style: TextStyle(fontSize: 20.0)),
          textColor: Colors.grey[500],
          color: Colors.grey[200],
        ),
      );
    } else if (this._currentBreak != null) {
      return _buildActive(
        context,
        countdown: this._currentBreak.countDowner(),
        progress: this._currentBreak.progress(),
        tag: "Take a break!",
        cancelButton: RaisedButton(
          onPressed: () => _handleCancelBreak(context),
          child: Text("Cancel", style: TextStyle(fontSize: 20.0)),
          textColor: Colors.grey[500],
          color: Colors.grey[200],
        ),
      );
    } else {
      return _buildInactive(context);
    }
  }

  Widget _buildInactive(BuildContext context) {
    final tagController = TextEditingController();
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoCompleteTextField<String>(
              controller: tagController,
              suggestions: _tags,
              itemSubmitted: (item) => tagController.text = item,
              submitOnSuggestionTap: false,
              minLength: 0,
              itemBuilder: (context, suggestion) => new Padding(
                  child: new ListTile(title: new Text(suggestion)),
                  padding: EdgeInsets.all(8.0)),
              itemSorter: (a, b) => a.compareTo(b),
              itemFilter: (item, query) =>
                  item.toLowerCase().indexOf(query.toLowerCase()) != -1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "What're you working on?",
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: RaisedButton(
                onPressed: () => _handleStartCycle(context, tagController.text),
                color: Colors.pink,
                child: Text(
                  'Start Work',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActive(BuildContext context,
      {String countdown,
      String tag,
      double progress,
      Widget completeButton,
      Widget cancelButton}) {
    List<Widget> widgets = <Widget>[];
    widgets.add(Text(
      countdown,
      style: Theme.of(context).textTheme.headline1,
    ));
    if (tag != "") {
      widgets.add(Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            tag,
            style: TextStyle(fontSize: 30.0, color: Colors.grey[500]),
          )));
    }
    if (completeButton != null) {
      widgets.add(completeButton);
    } else {
      widgets.add(Text(""));
    }
    widgets.add(cancelButton);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: CustomPaint(
                              painter: TimerPainter(
                                progress: progress,
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: FractionalOffset.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 100,
                                horizontal: 100.0,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: widgets,
                                ),
                              ),
                            )),
                      ],
                    ))))
      ],
    );
  }
}

class TimerPainter extends CustomPainter {
  double progress = 0;

  TimerPainter({this.progress}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[200]
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Colors.pink;
    double progress = this.progress * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return progress != old.progress;
  }
}
