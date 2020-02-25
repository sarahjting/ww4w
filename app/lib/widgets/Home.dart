import 'package:flutter/material.dart';
import 'Loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  bool _countDown = false;

  void _handleStart() {
    setState(() {
      _countDown = true;
    });
  }

  void _handleEnd() {
    setState(() {
      _countDown = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WW4W"),
      ),
      body: _loading
          ? Loading()
          : Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Task',
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Start Work'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
