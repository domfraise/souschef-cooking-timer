import 'package:flutter/material.dart';
import 'package:souschef_cooking_timer/components/duration_view.dart';
import 'package:souschef_cooking_timer/model/phase.dart';

class PhaseChip extends StatelessWidget {
  final Function editPhaseCallback;
  final Phase phase;
  final Duration initialDuration;

  PhaseChip(this.phase, this.editPhaseCallback, this.initialDuration);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primaryVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: InkWell(
        onLongPress: () {
          editPhaseCallback(phase);
        },
        onTap: () {
          editPhaseCallback(phase);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Text(
                phase.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                // style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              DurationView(
                duration: phase.timeRemaining,
                fontSize: 15,
                textColor: Theme.of(context).colorScheme.onPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  getWidth() {
    var relativeWidth =
        this.phase.initialDuration.inSeconds / this.initialDuration.inSeconds;
    if (relativeWidth <= 0.2) relativeWidth = 0.2;
    return relativeWidth * 340;
  }

  static getWidthWithoutMin(phaseDuration, totalDuration) {
    var relativeWidth = phaseDuration.inSeconds / totalDuration.inSeconds;
    return relativeWidth * 340;
  }
}
