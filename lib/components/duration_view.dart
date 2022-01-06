import 'package:flutter/material.dart';

class DurationView extends StatelessWidget {
  final Duration duration;
  final double fontSize;
  final Color textColor;

  DurationView({required this.duration, this.fontSize: 10, this.textColor: Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        getDisplayTime(duration),
        style: TextStyle(fontSize: this.fontSize,
            fontWeight: FontWeight.bold,
            color:textColor == null ? Theme.of(context).colorScheme.secondary : textColor )
      ),
    );
  }

  static String getDisplayTime(Duration duration) {
    var hours = duration.inHours.toString();
    var mins = (duration.inMinutes - duration.inHours * 60).toString();
    var secs = (duration.inSeconds - duration.inMinutes * 60).toString();
    if (mins.length == 1) mins = "0" + mins;
    if (secs.length == 1) secs = "0" + secs;
    return "$hours:$mins:$secs";
  }
}
