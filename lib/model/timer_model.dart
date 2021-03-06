import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:souschef/model/clock.dart';
import 'package:souschef/model/recipe.dart';
import 'package:souschef/model/timer_state.dart';

class TimerModel {
  Clock clock = Clock();
  Recipe recipe;
  bool hasStarted = false;
  Function alertCallback;
  TimeOfDay? _scheduledTime;
  Duration scheduledTimeRemaining = Duration.zero;
  Timer? scheduleTimer;
  Function showProgress;

  TimerModel(
      {required this.recipe,
      required this.alertCallback,
      required this.showProgress}) {
    ingredientsChanged();
    listenToClock();
  }

  set scheduledTime(TimeOfDay? time) {
    _scheduledTime = time;
    scheduleTimer?.cancel();
    if (!hasStarted && _scheduledTime != null) {
      this.scheduledTimeRemaining = Duration(minutes: calculateWaitTime(time!));
      scheduleTimer = Timer(scheduledTimeRemaining, () {
        _scheduledTime = null;
        alertCallback("Scheduled Timer Starting", recipe.name + "Starting now");
      });
      start();
    } else {
      _scheduledTime = null;
      scheduledTimeRemaining = Duration.zero;
    }
  }

  int calculateWaitTime(TimeOfDay finishTime) {
    var currentTime = TimeOfDay.now();
    var startingIn = (finishTime.minute + finishTime.hour * 60) -
        (currentTime.minute + currentTime.hour * 60) -
        recipe.initialDuration.inMinutes;
    print("starting in $startingIn");
    return startingIn;
  }

  TimeOfDay get scheduledTime => _scheduledTime ?? TimeOfDay.now();

  bool isScheduled(){
    return _scheduledTime != null;
  }

  bool isRunning() {
    return clock.isRunning();
  }

  void start() {
    clock.start();
    hasStarted = true;
    startService();
  }

  Stream<int> getTickStream() {
    return clock.getTickStream();
  }

  void listenToClock() {
    clock.getTickStream().listen((tick) {
      if (scheduledTimeRemaining != null &&
          scheduledTimeRemaining > Duration.zero) {
        scheduledTimeRemaining -= Duration(seconds: 1);
      } else {
        recipe.ingredients
            .where((ingredient) => ingredient.state != TimerState.FINISHED)
            .forEach((ingredient) {
          ingredient.decreaseDuration(tick);
        });
        if (totalTimeRemaining <= Duration.zero) {
          alertCallback("All timers done!", "Enjoy your meal");
          pause();
        }
      }
    });

    listenToService();
  }
  void listenToService(){
    FlutterBackgroundService().onDataReceived.forEach((element) {
      if (element == null) {
        return;
      } else if (element['action'] == "serviceReady") {
        updateDurationInService();
      } else if (element['action'] == "phaseComplete") {
        var serviceTotalTimeRemaining = element['totalTimeRemaining'];
        if(serviceTotalTimeRemaining < totalTimeRemaining.inSeconds) {
          print("app lag detected");
          clock.forceTicks(totalTimeRemaining.inSeconds - serviceTotalTimeRemaining);
        }
      }
    });
  }

  void pause() {
    clock.stop();
    sendServiceToBackground();
  }

  void resume() {
    clock.start();
    sendServiceToForground();
  }

  void alert() {
    alertCallback("All timers done!", "");
    print("All finshed!");
  }

  void ingredientsChanged() {
    _setOffsets();
  }

  Duration get totalTimeRemaining {
    Duration longestTimeRemaining = Duration(seconds: 0);
    recipe.ingredients.forEach((ingredient) {
      if (ingredient.timeRemaining > longestTimeRemaining)
        longestTimeRemaining = ingredient.timeRemaining;
    });
    return longestTimeRemaining;
  }

  void _setOffsets() {
    recipe.ingredients
        .where((ingredient) =>
            !hasStarted || ingredient.state != TimerState.RUNNING)
        .forEach((ingredient) {
      ingredient.offset = totalTimeRemaining - ingredient.timeRemaining;
      ingredient.initialOffset = ingredient.offset;
      if (ingredient.offset <= Duration.zero)
        ingredient.state = TimerState.RUNNING;
      else
        ingredient.state = TimerState.PENDING;
    });
  }

  void reset() {
    clock.stop();
    recipe.reset();
    _scheduledTime = null;
    scheduledTimeRemaining = Duration.zero;
    ingredientsChanged();
    hasStarted = false;
    stopService();
  }

  Duration getTimeUntilNextAlert(){
    return recipe.getNextAlertingPhase().timeTillNextAlert;
  }
  void sendServiceToForground() {
    FlutterBackgroundService().sendData({"action": "setAsForeground"});
  }
  void sendServiceToBackground() {
    FlutterBackgroundService().sendData({"action": "setAsBackground"});
  }
  void stopService() {
    FlutterBackgroundService().sendData({"action": "stopService"});
  }

  void startService() {
    final service = FlutterBackgroundService();
    service.start();
    _updateDurationByService(service);
  }

  void updateDurationInService(){
    _updateDurationByService(FlutterBackgroundService());
  }
  void _updateDurationByService(FlutterBackgroundService service) {
    service.sendData({"action": "updateDuration", "timeUntilNextAlert": getTimeUntilNextAlert().inSeconds, "totalTimeRemaining": totalTimeRemaining.inSeconds});
  }
}
