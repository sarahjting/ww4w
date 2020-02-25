import 'package:flutter/material.dart';
import 'widgets/TimerWidget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(App());
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  String page = "TIMER";

  Widget build(BuildContext context) {
    Widget tab = Container();
    if (page == "TIMER") tab = TimerWidget();
    return MaterialApp(
      title: 'Will Work For Waifus',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("WW4W"),
        ),
        body: tab,
      ),
    );
  }
}
