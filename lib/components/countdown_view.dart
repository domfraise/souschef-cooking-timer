import 'package:flutter/material.dart';
import 'package:souschef_cooking_timer/model/timer_model.dart';

import 'duration_view.dart';

class CountdownView extends StatelessWidget {
  final TimerModel timer;
   //todo can we move from timer to a duration?
  final Function playOrPauseCallback;
  final Function scheduleTimerCallback;
  final Function resetCallback;
  Duration durationTest;

  CountdownView(
      {required this.timer,
      required this.playOrPauseCallback,
      required this.scheduleTimerCallback,
      required this.resetCallback,
      this.durationTest: Duration.zero});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Total Time Remaining",
                    // style: Theme.of(context).textTheme.subhead,
                  ),
                  GestureDetector(
                    child: DurationView( duration: durationTest,
                      fontSize: 50,
                      textColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          child: timer.isRunning()
                              ? Icon(
                            Icons.pause,
                            size: 50,
                            color: Colors.white,
                          )
                              : Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            playOrPauseCallback(timer);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

}
