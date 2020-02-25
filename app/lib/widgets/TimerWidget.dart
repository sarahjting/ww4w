import 'package:flutter/material.dart';

import 'Loading.dart';
import 'dart:async';
import '../models/Cycle.dart';
import '../utils/CycleManager.dart';
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
      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCancel(context) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> res = await _manager.cancel();
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
            FractionallySizedBox(
              widthFactor: 1.0,
              child: RaisedButton(
                onPressed: () => _handleStart(context, tagController.text),
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

  Widget _buildActive(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    widgets.add(Text(
      _currentCycle.countDowner(),
      style: Theme.of(context).textTheme.headline1,
    ));
    if (_currentCycle.tag != "") {
      widgets.add(Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            _currentCycle.tag,
            style: TextStyle(fontSize: 30.0, color: Colors.grey[500]),
          )));
    }
    if (_secondsLeft == 0) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: RaisedButton(
            onPressed: () => _handleEnd(context),
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
        ),
      );
    } else {
      widgets.add(Text(""));
    }
    widgets.add(RaisedButton(
        onPressed: () => _handleCancel(context),
        child: Text("Cancel", style: TextStyle(fontSize: 20.0)),
        textColor: Colors.grey[500],
        color: Colors.grey[200]));

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
                                progress: _currentCycle.progress(),
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
