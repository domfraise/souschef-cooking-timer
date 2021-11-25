import 'phase.dart';
import 'timer_state.dart';

class IngredientModel {
  Duration offset = Duration.zero;
  String name;
  TimerState state = TimerState.PENDING;
  List<Phase> phases;
  Function alertCallback;
  bool isPaused = false;
  Duration initialOffset = Duration.zero;

  IngredientModel(
      {required this.name, required this.phases, required this.alertCallback});

  Duration get timeRemaining {
    Duration currentDuration = Duration(seconds: 0);
    phases.forEach((phase) {
      currentDuration = Duration(
          seconds: currentDuration.inSeconds + phase.timeRemaining.inSeconds);
    });
    return currentDuration;
  }

  Duration get initialDuration {
    return phases.fold(
        Duration.zero, (current, phase) => current + phase.initialDuration);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phases": phases.map((phase) => phase.toJson()).toList()
    };
  }

  static IngredientModel fromJson(
      Map<dynamic, dynamic> json, Function alertCallback) {
    List<Phase> phases = List.from(
        json['phases'].map((phase) => Phase.fromJson(phase)).toList());
    return IngredientModel(
        name: json['name'], phases: phases, alertCallback: alertCallback);
  }

  void decreaseDuration(int seconds) {
    print("Ingredient $name - ${timeRemaining.inSeconds}");
    if (state == TimerState.PENDING) {
      offset -= Duration(seconds: seconds);
      if (offset <= Duration.zero) {
        state = TimerState.RUNNING;
        ingredientStarting();
      }
    } else {
      if (isPaused) return;
      Phase currentPhase = phases.firstWhere(
          (phase) =>
              phase.state == TimerState.RUNNING ||
              phase.state == TimerState.PENDING, orElse: () {
        state = TimerState.FINISHED;
        return Phase();
      });
      var phaseDurationRemaining =
          currentPhase.decreaseDuration(seconds);
      if (phaseDurationRemaining <= Duration.zero) phaseDone(currentPhase);
      if (timeRemaining <= Duration.zero) {
        state = TimerState.FINISHED;
        ingredientDone();
      }
    }
  }

  void phaseDone(Phase currentPhase) {
    if (phases.indexOf(currentPhase) >= phases.length - 1) {
      // last phase
      alertCallback("$name: ${currentPhase.name} - Step Complete", "");
    } else {
      var nextPhase = phases[phases.indexOf(currentPhase) + 1];
      alertCallback("$name: ${currentPhase.name} - Step Complete",
          "$name: ${nextPhase.name} - Step Starting");
    }
  }

  void pause() {
    isPaused = true;
  }

  void resume() {
    isPaused = false;
  }

  void ingredientDone() {
    alertCallback("$name", "Ingredient Complete");
  }

  void ingredientStarting() {
    alertCallback(
        "$name", "Ingredient Starting. First step: ${phases[0].name}");
  }

  void reset() {
    state = TimerState.PENDING;
    phases.forEach((phase) {
      phase.reset();
    });
  }
}
