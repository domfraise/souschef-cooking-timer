import 'dart:async';
class Clock {
  Timer? timer;
  StreamController<int> _streamController = StreamController.broadcast();

  void start() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        _streamController.add(1);
      });
    }
  }

  void forceTicks(seconds){
    for (int i = 0 ; i < seconds; i++){
      _streamController.add(1);
    }
  }

  bool isRunning(){
    return timer != null && timer!.isActive;
  }

  Stream<int> getTickStream() {
    return _streamController.stream.asBroadcastStream();
  }

  void stop() {
    timer?.cancel();
  }
}
