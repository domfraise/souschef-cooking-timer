import 'package:souschef_cooking_timer/model/timer_state.dart';

class Phase {
  final Duration initialDuration;
  Duration timeRemaining;
  String name;
  String notes;
  TimerState state =  TimerState.PENDING;

  Phase({this.name="", this.notes="",this.initialDuration=Duration.zero}):
      timeRemaining = initialDuration;

  Duration decreaseDuration(int seconds){

    timeRemaining = Duration(seconds: timeRemaining.inSeconds - seconds);

    if(state == TimerState.PENDING) state = TimerState.RUNNING;

    if(timeRemaining.inSeconds <= 0){
      state = TimerState.FINISHED;
      timeRemaining = Duration.zero;
      print("$name - FINISHED");
    }
    return timeRemaining;
  }

  void reset() {
    timeRemaining = initialDuration;
    state = TimerState.PENDING;
  }

  Map<String, dynamic> toJson(){
    return {
      "duration": initialDuration.inSeconds,
      "name": name,
      "notes" : notes
    };
  }

  static Phase fromJson(json) {
    return Phase(name: json["name"], initialDuration: Duration(seconds: json["duration"]), notes: json["notes"]);
  }

}
