import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widgets/TimerWidget.dart';
import 'widgets/GachaWidget.dart';
import 'widgets/GalleryWidget.dart';

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
  int _gems = 0;

  void setGems(inGems) {
    setState(() => _gems = inGems);
  }

  int getGems() {
    return _gems;
  }

  Widget build(BuildContext context) {
    TimerWidget timerTab = TimerWidget(setGems);
    GachaWidget gachaTab = GachaWidget(setGems, getGems);
    GalleryWidget galleryTab = GalleryWidget();
    return MaterialApp(
      title: 'Will Work For Waifus',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
              title: Text("WW4W"),
              actions: <Widget>[
                FlatButton(
                    textColor: Colors.white,
                    onPressed: () => {},
                    child: Text(_gems.toString() + " Gems")),
              ],
              bottom: TabBar(isScrollable: false, tabs: [
                Tab(text: "Timer", icon: Icon(Icons.alarm)),
                Tab(text: "Gacha", icon: Icon(Icons.star)),
                Tab(text: "Collect", icon: Icon(Icons.view_module)),
                Tab(text: "History", icon: Icon(Icons.insert_chart)),
              ])),
          body: TabBarView(
            children: [timerTab, gachaTab, galleryTab, timerTab],
          ),
        ),
      ),
    );
  }
}
