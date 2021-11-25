import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:souschef_cooking_timer/components/countdown_view.dart';
import 'package:souschef_cooking_timer/model/recipe.dart';
import 'package:souschef_cooking_timer/model/timer_model.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);

  runApp(const MyApp());
}

void onStart() {
  var count = 1000;
  bool running = false;
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
    if (event["action"] == "play") {
      running = true;
    }

    if (event["action"] == "pause") {
      running = false;
    }
    if (event["action"] == "updateDuration") {
      count =event["duration"];
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );
    if (running) {
      count -= 1;
    }

    service.sendData(
      {"current_date": DateTime.now().toIso8601String(), "count": count},
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String targetCounter = "0";
  Duration targetDuration = Duration.zero;
  bool timerRunning = false;

  void _setDuration() {
    setState(() {

      FlutterBackgroundService().sendData(
        {"action": "updateDuration", "duration": targetDuration.inSeconds},
      );
    });
  }

  void pause() {
    setState(() {
      FlutterBackgroundService().sendData(
        {"action": "pause"},
      );
      timerRunning = false;
    });
  }

  void play() {
    setState(() {
      FlutterBackgroundService().sendData(
        {"action": "play"},
      );
      timerRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Target Count:',
                ),
                Text(
                  '$targetCounter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().onDataReceived,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                var timerModel = TimerModel(Recipe.empty(), () {}, () {});
                return Expanded(
                    child: CountdownView(
                        timer: timerModel,
                        playOrPauseCallback: (timer) {
                          if (timerRunning) {
                            pause();
                          } else {
                            play();
                          }
                        },
                        scheduleTimerCallback: () {},
                        resetCallback: () {},
                        durationTest: Duration(
                          seconds: data["count"],
                        ) //todo callbacks
                        ));
              },
            ),
            Expanded(
              child: buildTimePicker(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimePicker() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Duration",
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: CupertinoTimerPicker(
                initialTimerDuration: Duration.zero,
                onTimerDurationChanged: (duration) {
                  targetDuration = duration;
                  _setDuration();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
