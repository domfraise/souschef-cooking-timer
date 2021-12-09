import 'package:flutter/material.dart';

class ScheduleTimerDialogue extends StatefulWidget {
  final String title;
  final TimeOfDay initialValue;
  final Function submitCallback;

  ScheduleTimerDialogue(this.title, this.initialValue, this.submitCallback);

  @override
  _ScheduleTimerDialogueState createState() => _ScheduleTimerDialogueState();
}

class _ScheduleTimerDialogueState extends State<ScheduleTimerDialogue> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(widget.title)]),
      content: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FlatButton(
            onPressed: () async {
              var chosenTime = await _selectTime(context);
              if(timeInFuture(chosenTime)){
                showTimeInFutureDialogue(context);
              } else {
                selectedTime = chosenTime;
              }
              setState(() {});
            },
            child: Text(
              selectedTime == null ? "-- : --" : selectedTime!.format(context),
              // style: Theme.of(context).textTheme.button.copyWith(fontSize: 30),
            ),
          ),
          FlatButton.icon(
            icon: Icon(Icons.timer_off),
            onPressed: () {
              setState(() {
                selectedTime = null;
              });
            },
            label: Text("Clear"),
          )
        ]),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            widget.submitCallback(selectedTime);
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  Future _selectTime(context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked;
  }

  void showTimeInFutureDialogue(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Invalid Time"),
            content: Text("Please select a time in the future"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
    );
  }

}
bool timeInFuture(TimeOfDay selectedTime) {
  var now = TimeOfDay.now();
  if(selectedTime == null) return false;
  return (selectedTime.hour * 60 + selectedTime.minute) < (now.hour * 60 + now.minute );
}
