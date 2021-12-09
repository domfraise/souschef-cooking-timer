import 'package:flutter/services.dart';
import 'package:souschef_cooking_timer/model/timer_model.dart';

class BackgroundService{
  static const String CHANNEL_NAME = 'com.phraze.souschef/background';
  static const MethodChannel _channel = MethodChannel(CHANNEL_NAME);

  // static Future<int> listenForResponses(TimerModel timerModel) async {
  //   defaultBinaryMessenger.setMessageHandler(CHANNEL_NAME, (ByteData message) async {
  //     final int newTotalDuration = message.getInt32(0);
  //     print('RECIEVED new Total Duration: $newTotalDuration');
  //     var appLagInSeconds = timerModel.totalTimeRemaining.inSeconds - newTotalDuration;
  //     print("App lag in seconds: $appLagInSeconds");
  //     if (appLagInSeconds > 0){
  //       timerModel.clock.forceTicks(appLagInSeconds);
  //     }
  //     print("Total time remaining = ${timerModel.totalTimeRemaining}");
  //     if(timerModel.totalTimeRemaining > Duration.zero && timerModel.isRunning()){
  //       enqueueDurationToService(timerModel);
  //     }
  //     return message;
  //   });
  // }
  //
  // static Future<bool> startTimer(TimerModel timer) async {
  //   listenForResponses(timer);
  //    await enqueueDurationToService(timer);
  //   print("Timer started TTR: ${timer.totalTimeRemaining}, TTNA: ${timer.recipe.getNextAlertingPhase().timeTillNextAlert}");
  // }
  //
  // static Future enqueueDurationToService(TimerModel timer) async {
  //   await _channel.invokeMethod('start', <String, int>{
  //     'totalTimeRemaining': timer.totalTimeRemaining.inSeconds,
  //     'timeTillNextAlert': timer.recipe.getNextAlertingPhase().timeTillNextAlert.inSeconds,
  //   });
  // }
  //
  // static stopService() async {
  //   await _channel.invokeMethod('stop');
  // }


}
