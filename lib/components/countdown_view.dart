import 'package:flutter/material.dart';
import 'package:souschef/components/duration_view.dart';

import 'package:souschef/model/timer_model.dart';

class CountdownView extends StatelessWidget {
  final TimerModel timer;
  final Function playOrPauseCallback;
  final Function scheduleTimerCallback;
  final Function resetCallback;

  CountdownView(
      {required this.timer,
      required this.playOrPauseCallback,
      required this.scheduleTimerCallback,
      required this.resetCallback});

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
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  DurationView(
                    duration: timer.totalTimeRemaining,
                    fontSize: 50,
                    textColor: Theme.of(context).colorScheme.secondary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: FlatButton.icon(
                          icon: Icon(Icons.schedule),
                          label: !timer.isScheduled()
                              ? Text("Schedule", textScaleFactor: 0.95)
                              : DurationView(
                                  duration: timer.scheduledTimeRemaining,
                                ),
                          onPressed: () {
                            scheduleTimerCallback(timer);
                          },
                        ),
                      ),
                      FlatButton(
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
                      Expanded(
                        flex: 4,
                        child: FlatButton.icon(
                          icon: Icon(Icons.restore),
                          label: Text(
                            "Reset",
                          ),
                          onPressed: () {
                            resetCallback();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Up Next: ${timer.recipe.getNextAlertingPhase().ingredientName} - ${timer.recipe.getNextAlertingPhase().phaseName}",
                      style: Theme.of(context).textTheme.subtitle2
                  ),
                  DurationView(
                    duration:
                        timer.getTimeUntilNextAlert(),
                    fontSize: 30,
                    textColor: Theme.of(context).colorScheme.onSurface,
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
